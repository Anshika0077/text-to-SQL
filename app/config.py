"""Settings, read once from environment variables (or the .env file)."""

import os
from dataclasses import dataclass, field
from functools import lru_cache

from dotenv import load_dotenv

load_dotenv()  # reads .env and puts its values into os.environ


@dataclass(frozen=True)
class Settings:
    database_url: str = field(default_factory=lambda: os.getenv(
        "DATABASE_URL", "postgresql://analyst_ro:analyst_ro@localhost:5432/analytics"))

    llm_provider: str = field(default_factory=lambda: os.getenv("LLM_PROVIDER", "openai"))
    llm_model: str = field(default_factory=lambda: os.getenv("LLM_MODEL", "llama-3.3-70b-versatile"))
    llm_api_key: str = field(default_factory=lambda: os.getenv("LLM_API_KEY", ""))
    llm_base_url: str = field(default_factory=lambda: os.getenv("LLM_BASE_URL", ""))

    max_attempts: int = field(default_factory=lambda: int(os.getenv("MAX_ATTEMPTS", "3")))
    max_rows: int = field(default_factory=lambda: int(os.getenv("MAX_ROWS", "1000")))
    statement_timeout_ms: int = field(default_factory=lambda: int(os.getenv("STATEMENT_TIMEOUT_MS", "10000")))


@lru_cache
def get_settings() -> Settings:
    return Settings()