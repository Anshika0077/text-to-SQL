-- 1. Regions: no links to other tables, so it goes first
CREATE TABLE regions (
    region_id   SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    country     TEXT NOT NULL
);
COMMENT ON TABLE regions IS 'Sales regions the company operates in';

-- 2. Employees: each one belongs to a region
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    full_name   TEXT NOT NULL,
    role        TEXT NOT NULL,          -- Sales Rep, Senior Sales Rep, Regional Manager
    region_id   INT  NOT NULL REFERENCES regions(region_id),
    hire_date   DATE NOT NULL
);
COMMENT ON TABLE employees IS 'Sales staff; every order is handled by one sales rep';

-- 3. Customers: each one belongs to a region
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    email       TEXT NOT NULL UNIQUE,
    segment     TEXT NOT NULL,          -- Consumer, Corporate, Small Business
    city        TEXT NOT NULL,
    region_id   INT  NOT NULL REFERENCES regions(region_id),
    signup_date DATE NOT NULL
);
COMMENT ON TABLE customers IS 'People and companies that buy from us';

-- 4. Categories: no links, just a list of names
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE
);
COMMENT ON TABLE categories IS 'Product categories';

-- 5. Products: each one belongs to a category
CREATE TABLE products (
    product_id  SERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    category_id INT  NOT NULL REFERENCES categories(category_id),
    unit_price  NUMERIC(10,2) NOT NULL,  -- current list price
    unit_cost   NUMERIC(10,2) NOT NULL,  -- what one unit costs us
    launched_on DATE NOT NULL
);
COMMENT ON TABLE products IS 'Products in the catalogue';

-- 6. Orders: needs customers and employees to exist first
CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INT  NOT NULL REFERENCES customers(customer_id),
    sales_rep_id INT  NOT NULL REFERENCES employees(employee_id),
    order_date   DATE NOT NULL,
    status       TEXT NOT NULL,          -- Delivered, Shipped, Processing, Cancelled, Returned
    channel      TEXT NOT NULL           -- Online, Retail, Partner
);
COMMENT ON TABLE orders IS 'One row per order. Line items live in order_items';

-- 7. Order items: needs orders and products, so it goes last
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id),
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL,           -- price actually charged
    discount      NUMERIC(4,2)  NOT NULL DEFAULT 0  -- 0.10 means 10% off
);
COMMENT ON TABLE order_items IS 'Products and quantities inside each order';

-- Indexes on the columns we filter and join on most
CREATE INDEX idx_orders_date      ON orders(order_date);
CREATE INDEX idx_orders_customer  ON orders(customer_id);
CREATE INDEX idx_items_order      ON order_items(order_id);
CREATE INDEX idx_items_product    ON order_items(product_id);
CREATE INDEX idx_customers_region ON customers(region_id);