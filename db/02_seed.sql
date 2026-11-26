-- Makes random() give the same numbers every time we rebuild the data
SELECT setseed(0.42);

INSERT INTO regions (name, country) VALUES
    ('North',   'India'),
    ('West',    'India'),
    ('South',   'India'),
    ('East',    'India'),
    ('Central', 'India');

INSERT INTO categories (name) VALUES
    ('Electronics'),
    ('Furniture'),
    ('Office Supplies');

INSERT INTO employees (full_name, role, region_id, hire_date)
SELECT
    (ARRAY['Aarav','Vivaan','Ishaan','Diya','Ananya','Kabir','Meera','Rohan','Saanvi','Arjun',
           'Priya','Karan','Neha','Vikram','Tara','Rahul','Pooja','Aditi','Siddharth','Nisha',
           'Manish','Kavya','Yash','Riya','Dev'])[g]
    || ' ' ||
    (ARRAY['Sharma','Mehta','Iyer','Reddy','Das','Patel','Nair','Singh','Gupta','Bose',
           'Kapoor','Joshi','Rao','Menon','Verma','Malhotra','Chatterjee','Kulkarni','Pillai','Saxena',
           'Agarwal','Mishra','Shetty','Banerjee','Chauhan'])[g],
    CASE (g - 1) % 5
        WHEN 0 THEN 'Regional Manager'
        WHEN 1 THEN 'Senior Sales Rep'
        ELSE 'Sales Rep'
    END,
    ((g - 1) / 5) + 1,
    current_date - (400 + floor(random() * 2200))::int
FROM generate_series(1, 25) AS g;

INSERT INTO customers (name, email, segment, city, region_id, signup_date)
SELECT
    nm,
    lower(replace(nm, ' ', '.')) || '.' || g || '@example.com',
    seg,
    (ARRAY[['Delhi','Chandigarh','Lucknow','Jaipur'],
           ['Mumbai','Pune','Ahmedabad','Surat'],
           ['Bengaluru','Chennai','Hyderabad','Kochi'],
           ['Kolkata','Bhubaneswar','Patna','Guwahati'],
           ['Bhopal','Nagpur','Indore','Raipur']])[r][(floor(random() * 4) + 1)::int],
    r,
    current_date - (30 + floor(random() * 1300))::int
FROM (
    SELECT
        g,
        CASE WHEN rr < 0.28 THEN 1 WHEN rr < 0.52 THEN 2 WHEN rr < 0.72 THEN 3
             WHEN rr < 0.88 THEN 4 ELSE 5 END AS r,
        CASE WHEN rs < 0.50 THEN 'Consumer' WHEN rs < 0.80 THEN 'Corporate'
             ELSE 'Small Business' END AS seg,
        CASE WHEN rs < 0.50 THEN
            (ARRAY['Amit','Sneha','Rajesh','Lakshmi','Farhan','Anjali','Suresh','Divya','Harsh','Ira',
                   'Gaurav','Shreya','Nikhil','Simran','Varun','Pallavi','Imran','Kriti','Om','Zoya'])[(floor(random()*20)+1)::int]
            || ' ' ||
            (ARRAY['Kumar','Sharma','Khan','Iyer','Ghosh','Patil','Reddy','Jain','Thomas','Yadav',
                   'Desai','Mukherjee','Naidu','Arora','Sinha'])[(floor(random()*15)+1)::int]
        ELSE
            (ARRAY['Apex','Bluewave','Crescent','Deccan','Evergreen','Falcon','Ganga','Horizon','Indus','Jupiter',
                   'Kaveri','Lotus','Meridian','Nimbus','Orion','Pinnacle','Quantum','Sahyadri','Trident','Vertex'])[(floor(random()*20)+1)::int]
            || ' ' ||
            (ARRAY['Technologies','Traders','Solutions','Enterprises','Consulting','Logistics','Labs','Industries'])[(floor(random()*8)+1)::int]
        END AS nm
    FROM (SELECT g, random() AS rr, random() AS rs FROM generate_series(1, 800) AS g) AS base
) AS s;

INSERT INTO products (name, category_id, unit_price, unit_cost, launched_on) VALUES
    ('Laptop Pro 14',              1, 89999, 71000, current_date - 1500),
    ('Laptop Air 13',              1, 64999, 50500, current_date - 1400),
    ('27-inch 4K Monitor',         1, 28999, 21000, current_date - 1600),
    ('24-inch FHD Monitor',        1, 11999,  8400, current_date - 1700),
    ('Wireless Mouse',             1,  1299,   520, current_date - 1800),
    ('Mechanical Keyboard',        1,  4499,  2300, current_date - 1650),
    ('Noise-Cancelling Headset',   1,  7999,  4600, current_date - 1200),
    ('USB-C Docking Station',      1,  9499,  6100, current_date - 900),
    ('HD Webcam',                  1,  3499,  1700, current_date - 1300),
    ('Laser Printer',              1, 18999, 14200, current_date - 1750),
    ('Tablet 11',                  1, 32999, 25500, current_date - 700),
    ('Portable SSD 1TB',           1,  8999,  5900, current_date - 600),
    ('Ergonomic Office Chair',     2, 15999,  9800, current_date - 1800),
    ('Standing Desk',              2, 34999, 24000, current_date - 1100),
    ('Executive Desk',             2, 42999, 30500, current_date - 1800),
    ('Bookshelf',                  2,  8999,  5200, current_date - 1800),
    ('Filing Cabinet',             2, 11499,  7600, current_date - 1800),
    ('Conference Table',           2, 74999, 52000, current_date - 1500),
    ('Visitor Chair',              2,  4999,  2900, current_date - 1800),
    ('Monitor Arm',                2,  3999,  2100, current_date - 800),
    ('A4 Paper Ream',              3,   349,   210, current_date - 1800),
    ('Ballpoint Pens (Box of 50)', 3,   499,   240, current_date - 1800),
    ('Sticky Notes Pack',          3,   299,   120, current_date - 1800),
    ('Stapler',                    3,   399,   180, current_date - 1800),
    ('Whiteboard 4x3',             3,  3499,  2000, current_date - 1800),
    ('Whiteboard Markers',         3,   449,   190, current_date - 1800),
    ('Desk Organizer',             3,   899,   430, current_date - 1500),
    ('Printer Toner',              3,  4299,  2900, current_date - 1750),
    ('Notebook Pack (5)',          3,   599,   280, current_date - 1800),
    ('Paper Shredder',             3,  7499,  4800, current_date - 1200);

-- 1. Regular orders, weighted towards recent dates (business is growing)
INSERT INTO orders (customer_id, sales_rep_id, order_date, status, channel)
SELECT
    c.customer_id,
    (c.region_id - 1) * 5 + (floor(random() * 5) + 1)::int,
    o.d,
    CASE WHEN rs < 0.80 THEN 'Delivered' WHEN rs < 0.86 THEN 'Shipped' WHEN rs < 0.88 THEN 'Processing'
         WHEN rs < 0.95 THEN 'Cancelled' ELSE 'Returned' END,
    CASE WHEN rc < 0.55 THEN 'Online' WHEN rc < 0.85 THEN 'Retail' ELSE 'Partner' END
FROM (
    SELECT
        (floor(random() * 800) + 1)::int AS cid,
        current_date - floor(1095 * power(random(), 1.3))::int AS d,
        random() AS rs, random() AS rc
    FROM generate_series(1, 6800)
) AS o
JOIN customers c ON c.customer_id = o.cid;

-- 2. Festive-season bump: extra orders every October to December
INSERT INTO orders (customer_id, sales_rep_id, order_date, status, channel)
SELECT
    c.customer_id,
    (c.region_id - 1) * 5 + (floor(random() * 5) + 1)::int,
    o.d,
    CASE WHEN rs < 0.82 THEN 'Delivered' WHEN rs < 0.88 THEN 'Shipped' WHEN rs < 0.90 THEN 'Processing'
         WHEN rs < 0.96 THEN 'Cancelled' ELSE 'Returned' END,
    CASE WHEN rc < 0.60 THEN 'Online' WHEN rc < 0.88 THEN 'Retail' ELSE 'Partner' END
FROM (
    SELECT
        (floor(random() * 800) + 1)::int AS cid,
        make_date(extract(year FROM current_date)::int - (floor(random() * 3))::int,
                  10 + (floor(random() * 3))::int,
                  1 + (floor(random() * 28))::int) AS d,
        random() AS rs, random() AS rc
    FROM generate_series(1, 1500)
) AS o
JOIN customers c ON c.customer_id = o.cid
WHERE o.d <= current_date
  AND o.d >= current_date - 1095;

-- 3. Orders from the last week can't be delivered yet
UPDATE orders
SET status = CASE WHEN random() < 0.5 THEN 'Processing' ELSE 'Shipped' END
WHERE order_date > current_date - 7
  AND status IN ('Delivered', 'Returned');

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount)
SELECT
    x.order_id,
    p.product_id,
    CASE WHEN p.category_id = 3 THEN (1 + floor(random() * 10))::int
         ELSE (1 + floor(power(random(), 2) * 4))::int END,
    p.unit_price,
    CASE WHEN rd < 0.70 THEN 0 WHEN rd < 0.82 THEN 0.05 WHEN rd < 0.92 THEN 0.10
         WHEN rd < 0.97 THEN 0.15 ELSE 0.20 END
FROM (
    SELECT o.order_id,
           (floor(random() * 30) + 1 + 0 * o.order_id)::int AS pid,
           random() AS rd
    FROM orders o,
         LATERAL generate_series(1, (1 + floor(random() * 4) + 0 * o.order_id)::int)
) AS x
JOIN products p ON p.product_id = x.pid;

-- Refresh Postgres's statistics so queries plan well on the new data
ANALYZE;