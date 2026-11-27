"""Database access. Every query runs read-only, with a time limit."""

import atexit
import decimal
import time
from dataclasses import dataclass
from functools import lru_cache

import pandas as pd
import psycopg
from psycopg_pool import ConnectionPool

from app.config import get_settings


class QueryExecutionError(Exception):
    """Raised when Postgres rejects a query. The message is shown to the LLM later."""


@dataclass
class ExecutionResult:
    df: pd.DataFrame      # the result table
    row_count: int
    truncated: bool       # True if there were more rows than max_rows
    elapsed_ms: float     # how long the query took


@lru_cache
def get_pool() -> ConnectionPool:
    pool = ConnectionPool(get_settings().database_url, min_size=1, max_size=5, open=True)
    atexit.register(pool.close)   # close connections cleanly when Python exits
    return pool


def _clean(value):
    """Postgres returns NUMERIC as Decimal; pandas and charts prefer float."""
    if isinstance(value, decimal.Decimal):
        return float(value)
    return value


def run_readonly_query(sql: str, max_rows: int | None = None, timeout_ms: int | None = None) -> ExecutionResult:
    settings = get_settings()
    max_rows = max_rows or settings.max_rows
    timeout_ms = timeout_ms or settings.statement_timeout_ms

    start = time.perf_counter()
    try:
        with get_pool().connection() as conn:
            with conn.transaction():
                with conn.cursor() as cur:
                    cur.execute("SET TRANSACTION READ ONLY")
                    cur.execute(f"SET LOCAL statement_timeout = {int(timeout_ms)}")
                    cur.execute(sql)
                    if cur.description is None:
                        raise QueryExecutionError("Query returned no result set.")
                    columns = [d.name for d in cur.description]
                    rows = cur.fetchmany(max_rows + 1)
    except psycopg.errors.QueryCanceled as exc:
        raise QueryExecutionError(f"Query took longer than {timeout_ms} ms and was cancelled.") from exc
    except psycopg.Error as exc:
        diag = getattr(exc, "diag", None)
        message = diag.message_primary if diag and diag.message_primary else str(exc)
        raise QueryExecutionError(message.strip()) from exc

    truncated = len(rows) > max_rows
    rows = rows[:max_rows]
    df = pd.DataFrame([[_clean(v) for v in row] for row in rows], columns=columns)
    return ExecutionResult(
        df=df,
        row_count=len(df),
        truncated=truncated,
        elapsed_ms=(time.perf_counter() - start) * 1000,
    )