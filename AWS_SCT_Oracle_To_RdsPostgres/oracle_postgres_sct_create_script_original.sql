-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS co;

CREATE SCHEMA IF NOT EXISTS hr;

-- ------------ Write CREATE-SEQUENCE-stage scripts -----------

CREATE SEQUENCE IF NOT EXISTS co.seq_customers$def_on_null
INCREMENT BY 1
START WITH 393
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS co.seq_inventory$def_on_null
INCREMENT BY 1
START WITH 567
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS co.seq_orders$def_on_null
INCREMENT BY 1
START WITH 1951
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS co.seq_products$def_on_null
INCREMENT BY 1
START WITH 47
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS co.seq_shipments$def_on_null
INCREMENT BY 1
START WITH 2027
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS co.seq_stores$def_on_null
INCREMENT BY 1
START WITH 24
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 20;

CREATE SEQUENCE IF NOT EXISTS hr.departments_seq
INCREMENT BY 10
START WITH 1
MAXVALUE 9990
MINVALUE 1
NO CYCLE
CACHE 1;

CREATE SEQUENCE IF NOT EXISTS hr.employees_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 9223372036854775807
MINVALUE 1
NO CYCLE
CACHE 1;

CREATE SEQUENCE IF NOT EXISTS hr.locations_seq
INCREMENT BY 100
START WITH 1
MAXVALUE 9900
MINVALUE 1
NO CYCLE
CACHE 1;

-- ------------ Write CREATE-TABLE-stage scripts -----------

CREATE TABLE co.customers(
    customer_id BIGINT NOT NULL,
    email_address CHARACTER VARYING(255) NOT NULL,
    full_name CHARACTER VARYING(255) NOT NULL
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.customers
     IS 'Details of the people placing orders';
COMMENT ON COLUMN co.customers.customer_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.customers.email_address
     IS 'The email address the person uses to access the account';
COMMENT ON COLUMN co.customers.full_name
     IS 'What this customer is called';

CREATE TABLE co.inventory(
    inventory_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    product_inventory NUMERIC(38,0) NOT NULL
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.inventory
     IS 'Details of the quantity of stock available for products at each location';
COMMENT ON COLUMN co.inventory.inventory_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.inventory.store_id
     IS 'Which location the goods are located at';
COMMENT ON COLUMN co.inventory.product_id
     IS 'Which item this stock is for';
COMMENT ON COLUMN co.inventory.product_inventory
     IS 'The current quantity in stock';

CREATE TABLE co.order_items(
    order_id NUMERIC(38,0) NOT NULL,
    line_item_id NUMERIC(38,0) NOT NULL,
    product_id NUMERIC(38,0) NOT NULL,
    unit_price DOUBLE PRECISION NOT NULL,
    quantity NUMERIC(38,0) NOT NULL,
    shipment_id NUMERIC(38,0)
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.order_items
     IS 'Details of which products the customer has purchased in an order';
COMMENT ON COLUMN co.order_items.order_id
     IS 'The order these products belong to';
COMMENT ON COLUMN co.order_items.line_item_id
     IS 'An incrementing number, starting at one for each order';
COMMENT ON COLUMN co.order_items.product_id
     IS 'Which item was purchased';
COMMENT ON COLUMN co.order_items.unit_price
     IS 'How much the customer paid for one item of the product';
COMMENT ON COLUMN co.order_items.quantity
     IS 'How many items of this product the customer purchased';
COMMENT ON COLUMN co.order_items.shipment_id
     IS 'Where this product will be delivered';

CREATE TABLE co.orders(
    order_id BIGINT NOT NULL,
    order_tms TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    order_status CHARACTER VARYING(10) NOT NULL,
    store_id NUMERIC(38,0) NOT NULL
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.orders
     IS 'Details of who made purchases where';
COMMENT ON COLUMN co.orders.order_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.orders.order_tms
     IS 'When the order was placed';
COMMENT ON COLUMN co.orders.customer_id
     IS 'Who placed this order';
COMMENT ON COLUMN co.orders.order_status
     IS 'What state the order is in. Valid values are:
OPEN - the order is in progress
PAID - money has been received from the customer for this order
SHIPPED - the products have been dispatched to the customer
COMPLETE - the customer has received the order
CANCELLED - the customer has stopped the order
REFUNDED - there has been an issue with the order and the money has been returned to the customer';
COMMENT ON COLUMN co.orders.store_id
     IS 'Where this order was placed';

CREATE TABLE co.products(
    product_id BIGINT NOT NULL,
    product_name CHARACTER VARYING(255) NOT NULL,
    unit_price DOUBLE PRECISION,
    product_details BYTEA,
    product_image BYTEA,
    image_mime_type CHARACTER VARYING(512),
    image_filename CHARACTER VARYING(512),
    image_charset CHARACTER VARYING(512),
    image_last_updated TIMESTAMP(0) WITHOUT TIME ZONE
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.products
     IS 'Details of goods that customers can purchase';
COMMENT ON COLUMN co.products.product_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.products.product_name
     IS 'What a product is called';
COMMENT ON COLUMN co.products.unit_price
     IS 'The monetary value of one item of this product';
COMMENT ON COLUMN co.products.product_details
     IS 'Further details of the product stored in JSON format';
COMMENT ON COLUMN co.products.product_image
     IS 'A picture of the product';
COMMENT ON COLUMN co.products.image_mime_type
     IS 'The mime-type of the product image';
COMMENT ON COLUMN co.products.image_filename
     IS 'The name of the file loaded in the image column';
COMMENT ON COLUMN co.products.image_charset
     IS 'The character set used to encode the image';
COMMENT ON COLUMN co.products.image_last_updated
     IS 'The date the image was last changed';

CREATE TABLE co.shipments(
    shipment_id BIGINT NOT NULL,
    store_id NUMERIC(38,0) NOT NULL,
    customer_id NUMERIC(38,0) NOT NULL,
    delivery_address CHARACTER VARYING(512) NOT NULL,
    shipment_status CHARACTER VARYING(100) NOT NULL
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.shipments
     IS 'Details of where ordered goods will be delivered';
COMMENT ON COLUMN co.shipments.shipment_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.shipments.store_id
     IS 'Which location the goods will be transported from';
COMMENT ON COLUMN co.shipments.customer_id
     IS 'Who this shipment is for';
COMMENT ON COLUMN co.shipments.delivery_address
     IS 'Where the goods will be transported to';
COMMENT ON COLUMN co.shipments.shipment_status
     IS 'The current status of the shipment. Valid values are:
CREATED - the shipment is ready for order assignment
SHIPPED - the goods have been dispatched
IN-TRANSIT - the goods are en-route to their destination
DELIVERED - the good have arrived at their destination';

CREATE TABLE co.stores(
    store_id BIGINT NOT NULL,
    store_name CHARACTER VARYING(255) NOT NULL,
    web_address CHARACTER VARYING(100),
    physical_address CHARACTER VARYING(512),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    logo BYTEA,
    logo_mime_type CHARACTER VARYING(512),
    logo_filename CHARACTER VARYING(512),
    logo_charset CHARACTER VARYING(512),
    logo_last_updated TIMESTAMP(0) WITHOUT TIME ZONE
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE co.stores
     IS 'Physical and virtual locations where people can purchase products';
COMMENT ON COLUMN co.stores.store_id
     IS 'Auto-incrementing primary key';
COMMENT ON COLUMN co.stores.store_name
     IS 'What the store is called';
COMMENT ON COLUMN co.stores.web_address
     IS 'The URL of a virtual store';
COMMENT ON COLUMN co.stores.physical_address
     IS 'The postal address of this location';
COMMENT ON COLUMN co.stores.latitude
     IS 'The north-south position of a physical store';
COMMENT ON COLUMN co.stores.longitude
     IS 'The east-west position of a physical store';
COMMENT ON COLUMN co.stores.logo
     IS 'An image used by this store';
COMMENT ON COLUMN co.stores.logo_mime_type
     IS 'The mime-type of the store logo';
COMMENT ON COLUMN co.stores.logo_filename
     IS 'The name of the file loaded in the image column';
COMMENT ON COLUMN co.stores.logo_charset
     IS 'The character set used to encode the image';
COMMENT ON COLUMN co.stores.logo_last_updated
     IS 'The date the image was last changed';

CREATE TABLE hr.countries(
    country_id CHARACTER(2) NOT NULL,
    country_name CHARACTER VARYING(60),
    region_id NUMERIC
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.countries
     IS 'country table. References with locations table.';
COMMENT ON COLUMN hr.countries.country_id
     IS 'Primary key of countries table.';
COMMENT ON COLUMN hr.countries.country_name
     IS 'Country name';
COMMENT ON COLUMN hr.countries.region_id
     IS 'Region ID for the country. Foreign key to region_id column in the departments table.';

CREATE TABLE hr.departments(
    department_id INTEGER NOT NULL,
    department_name CHARACTER VARYING(30) NOT NULL,
    manager_id INTEGER,
    location_id INTEGER
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.departments
     IS 'Departments table that shows details of departments where employees
work. references with locations, employees, and job_history tables.';
COMMENT ON COLUMN hr.departments.department_id
     IS 'Primary key column of departments table.';
COMMENT ON COLUMN hr.departments.department_name
     IS 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';
COMMENT ON COLUMN hr.departments.manager_id
     IS 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';
COMMENT ON COLUMN hr.departments.location_id
     IS 'Location id where a department is located. Foreign key to location_id column of locations table.';

CREATE TABLE hr.employees(
    employee_id INTEGER NOT NULL,
    first_name CHARACTER VARYING(20),
    last_name CHARACTER VARYING(25) NOT NULL,
    email CHARACTER VARYING(25) NOT NULL,
    phone_number CHARACTER VARYING(20),
    hire_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    job_id CHARACTER VARYING(10) NOT NULL,
    salary DOUBLE PRECISION,
    commission_pct DOUBLE PRECISION,
    manager_id INTEGER,
    department_id INTEGER
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.employees
     IS 'employees table. References with departments,
jobs, job_history tables. Contains a self reference.';
COMMENT ON COLUMN hr.employees.employee_id
     IS 'Primary key of employees table.';
COMMENT ON COLUMN hr.employees.first_name
     IS 'First name of the employee. A not null column.';
COMMENT ON COLUMN hr.employees.last_name
     IS 'Last name of the employee. A not null column.';
COMMENT ON COLUMN hr.employees.email
     IS 'Email id of the employee';
COMMENT ON COLUMN hr.employees.phone_number
     IS 'Phone number of the employee; includes country code and area code';
COMMENT ON COLUMN hr.employees.hire_date
     IS 'Date when the employee started on this job. A not null column.';
COMMENT ON COLUMN hr.employees.job_id
     IS 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';
COMMENT ON COLUMN hr.employees.salary
     IS 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';
COMMENT ON COLUMN hr.employees.commission_pct
     IS 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';
COMMENT ON COLUMN hr.employees.manager_id
     IS 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';
COMMENT ON COLUMN hr.employees.department_id
     IS 'Department id where employee works; foreign key to department_id
column of the departments table';

CREATE TABLE hr.job_history(
    employee_id INTEGER NOT NULL,
    start_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    end_date TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    job_id CHARACTER VARYING(10) NOT NULL,
    department_id INTEGER
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.job_history
     IS 'Table that stores job history of the employees. If an employee
changes departments within the job or changes jobs within the department,
new rows get inserted into this table with old job information of the
employee. Contains a complex primary key: employee_id+start_date.
References with jobs, employees, and departments tables.';
COMMENT ON COLUMN hr.job_history.employee_id
     IS 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';
COMMENT ON COLUMN hr.job_history.start_date
     IS 'A not null column in the complex primary key employee_id+start_date.
Must be less than the end_date of the job_history table. (enforced by
constraint jhist_date_interval)';
COMMENT ON COLUMN hr.job_history.end_date
     IS 'Last day of the employee in this job role. A not null column. Must be
greater than the start_date of the job_history table.
(enforced by constraint jhist_date_interval)';
COMMENT ON COLUMN hr.job_history.job_id
     IS 'Job role in which the employee worked in the past; foreign key to
job_id column in the jobs table. A not null column.';
COMMENT ON COLUMN hr.job_history.department_id
     IS 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';

CREATE TABLE hr.jobs(
    job_id CHARACTER VARYING(10) NOT NULL,
    job_title CHARACTER VARYING(35) NOT NULL,
    min_salary INTEGER,
    max_salary INTEGER
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.jobs
     IS 'jobs table with job titles and salary ranges.
References with employees and job_history table.';
COMMENT ON COLUMN hr.jobs.job_id
     IS 'Primary key of jobs table.';
COMMENT ON COLUMN hr.jobs.job_title
     IS 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
COMMENT ON COLUMN hr.jobs.min_salary
     IS 'Minimum salary for a job title.';
COMMENT ON COLUMN hr.jobs.max_salary
     IS 'Maximum salary for a job title';

CREATE TABLE hr.locations(
    location_id INTEGER NOT NULL,
    street_address CHARACTER VARYING(40),
    postal_code CHARACTER VARYING(12),
    city CHARACTER VARYING(30) NOT NULL,
    state_province CHARACTER VARYING(25),
    country_id CHARACTER(2)
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.locations
     IS 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. references with the departments and countries tables. ';
COMMENT ON COLUMN hr.locations.location_id
     IS 'Primary key of locations table';
COMMENT ON COLUMN hr.locations.street_address
     IS 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
COMMENT ON COLUMN hr.locations.postal_code
     IS 'Postal code of the location of an office, warehouse, or production site
of a company. ';
COMMENT ON COLUMN hr.locations.city
     IS 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';
COMMENT ON COLUMN hr.locations.state_province
     IS 'State or Province where an office, warehouse, or production site of a
company is located.';
COMMENT ON COLUMN hr.locations.country_id
     IS 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';

CREATE TABLE hr.regions(
    region_id NUMERIC NOT NULL,
    region_name CHARACTER VARYING(25)
)
        WITH (
        OIDS=FALSE
        );
COMMENT ON TABLE hr.regions
     IS 'Regions table that contains region numbers and names. references with the Countries table.';
COMMENT ON COLUMN hr.regions.region_id
     IS 'Primary key of regions table.';
COMMENT ON COLUMN hr.regions.region_name
     IS 'Names of regions. Locations are in the countries of these regions.';

CREATE TABLE hr.time_range_sales(
    prod_id INTEGER NOT NULL,
    cust_id NUMERIC,
    time_id TIMESTAMP(0) WITHOUT TIME ZONE,
    quantity_sold INTEGER,
    amount_sold DOUBLE PRECISION
)
    PARTITION BY RANGE (time_id)
        WITH (
        OIDS=FALSE
        );

-- ------------ Write CREATE-PARTITION-stage scripts -----------

CREATE TABLE hr.time_range_sales_sales_apr2024
        PARTITION OF hr.time_range_sales
        FOR VALUES FROM ('2024-04-01 00:00:00') TO ('2024-05-01 00:00:00');

CREATE TABLE hr.time_range_sales_sales_feb2024
        PARTITION OF hr.time_range_sales
        FOR VALUES FROM ('2024-02-01 00:00:00') TO ('2024-03-01 00:00:00');

CREATE TABLE hr.time_range_sales_sales_jan2024
        PARTITION OF hr.time_range_sales
        FOR VALUES FROM (MINVALUE) TO ('2024-02-01 00:00:00');

CREATE TABLE hr.time_range_sales_sales_mar2024
        PARTITION OF hr.time_range_sales
        FOR VALUES FROM ('2024-03-01 00:00:00') TO ('2024-04-01 00:00:00');

-- ------------ Write CREATE-VIEW-stage scripts -----------

CREATE OR REPLACE  VIEW co.customer_order_products (order_id, order_tms, order_status, customer_id, email_address, full_name, order_total, items) AS
SELECT
    o.order_id, o.order_tms, o.order_status, c.customer_id, c.email_address, c.full_name, SUM(oi.quantity * oi.unit_price) AS order_total, STRING_AGG(p.product_name, ', '::TEXT ORDER BY oi.line_item_id) AS items
    FROM co.orders AS o
    JOIN co.order_items AS oi
        ON o.order_id = oi.order_id
    JOIN co.customers AS c
        ON o.customer_id = c.customer_id
    JOIN co.products AS p
        ON oi.product_id = p.product_id
    GROUP BY o.order_id, o.order_tms, o.order_status, c.customer_id, c.email_address, c.full_name;
COMMENT ON view co.customer_order_products
    IS 'A summary of who placed each order and what they bought';
COMMENT ON COLUMN co.customer_order_products.order_id
    IS 'The primary key of the order';
COMMENT ON COLUMN co.customer_order_products.order_tms
    IS 'The date and time the order was placed';
COMMENT ON COLUMN co.customer_order_products.order_status
    IS 'The current state of this order';
COMMENT ON COLUMN co.customer_order_products.customer_id
    IS 'The primary key of the customer';
COMMENT ON COLUMN co.customer_order_products.email_address
    IS 'The email address the person uses to access the account';
COMMENT ON COLUMN co.customer_order_products.full_name
    IS 'What this customer is called';
COMMENT ON COLUMN co.customer_order_products.order_total
    IS 'The total amount the customer paid for the order';
COMMENT ON COLUMN co.customer_order_products.items
    IS 'A comma-separated list naming the products in this order';

CREATE OR REPLACE  VIEW co.product_orders (product_name, order_status, total_sales, order_count) AS
SELECT
    p.product_name, o.order_status, SUM(oi.quantity * oi.unit_price) AS total_sales, COUNT(*) AS order_count
    FROM co.orders AS o
    JOIN co.order_items AS oi
        ON o.order_id = oi.order_id
    JOIN co.customers AS c
        ON o.customer_id = c.customer_id
    JOIN co.products AS p
        ON oi.product_id = p.product_id
    GROUP BY p.product_name, o.order_status;
COMMENT ON view co.product_orders
    IS 'A summary of the state of the orders placed for each product';
COMMENT ON COLUMN co.product_orders.product_name
    IS 'What this product is called';
COMMENT ON COLUMN co.product_orders.order_status
    IS 'The current state of these order';
COMMENT ON COLUMN co.product_orders.total_sales
    IS 'The total value of orders placed';
COMMENT ON COLUMN co.product_orders.order_count
    IS 'The total number of orders placed';

CREATE OR REPLACE  VIEW co.product_reviews (text, error_msg) AS
SELECT 'CREATE OR REPLACE FORCE VIEW CO.PRODUCT_REVIEWS(PRODUCT_NAME, RATING, AVG_RATING, REVIEW) AS 
SELECT p.product_name, r.rating,
         ROUND (
           AVG ( r.rating ) over (
             PARTITION BY product_name
           ),
           2
         ) avg_rating,
         r.review
  FROM   products p,
         JSON_TABLE (
           p.product_details, ''$''
           COLUMNS (
             NESTED PATH ''$.reviews[*]''
             COLUMNS (
               rating INTEGER PATH ''$.rating'',
               review VARCHAR2(4000) PATH ''$.review''
             )
           )
         ) r;'::varchar AS text,'9996 - Severity CRITICAL - Transformer error occurred in plSqlStatement. Please submit report to developers.
'::varchar AS error_msg;
COMMENT ON view co.product_reviews
    IS 'A relational view of the reviews stored in the JSON for each product';

CREATE OR REPLACE  VIEW co.store_orders (total, store_name, address, latitude, longitude, order_status, order_count, total_sales) AS
SELECT
    CASE grouping(store_name, order_status)
        WHEN 1 THEN 'STORE TOTAL'
        WHEN 2 THEN 'STATUS TOTAL'
        WHEN 3 THEN 'GRAND TOTAL'
    END AS total, s.store_name, COALESCE(s.web_address, s.physical_address) AS address, s.latitude, s.longitude, o.order_status, COUNT(DISTINCT o.order_id) AS order_count, SUM(oi.quantity * oi.unit_price) AS total_sales
    FROM co.stores AS s
    JOIN co.orders AS o
        ON s.store_id = o.store_id
    JOIN co.order_items AS oi
        ON o.order_id = oi.order_id
    GROUP BY GROUPING SETS ((s.store_name, COALESCE(s.web_address, s.physical_address), s.latitude, s.longitude), (s.store_name, COALESCE(s.web_address, s.physical_address), s.latitude, s.longitude, o.order_status), o.order_status, ());
COMMENT ON view co.store_orders
    IS 'A summary of what was purchased at each location, including summaries each store, order status and overall total';
COMMENT ON COLUMN co.store_orders.total
    IS 'Indicates what type of total is displayed, including Store, Status, or Grand Totals';
COMMENT ON COLUMN co.store_orders.store_name
    IS 'What the store is called';
COMMENT ON COLUMN co.store_orders.address
    IS 'The physical or virtual location of this store';
COMMENT ON COLUMN co.store_orders.latitude
    IS 'The north-south position of a physical store';
COMMENT ON COLUMN co.store_orders.longitude
    IS 'The east-west position of a physical store';
COMMENT ON COLUMN co.store_orders.order_status
    IS 'The current state of this order';
COMMENT ON COLUMN co.store_orders.order_count
    IS 'The total number of orders placed';
COMMENT ON COLUMN co.store_orders.total_sales
    IS 'The total value of orders placed';

CREATE OR REPLACE  VIEW hr.emp_details_view (employee_id, job_id, manager_id, department_id, location_id, country_id, first_name, last_name, salary, commission_pct, department_name, job_title, city, state_province, country_name, region_name) AS
SELECT
    e.employee_id, e.job_id, e.manager_id, e.department_id, d.location_id, l.country_id, e.first_name, e.last_name, e.salary, e.commission_pct, d.department_name, j.job_title, l.city, l.state_province, c.country_name, r.region_name
    FROM hr.employees AS e, hr.departments AS d, hr.jobs AS j, hr.locations AS l, hr.countries AS c, hr.regions AS r
    WHERE e.department_id = d.department_id AND d.location_id = l.location_id AND l.country_id = c.country_id AND c.region_id = r.region_id AND j.job_id = e.job_id;

-- ------------ Write CREATE-INDEX-stage scripts -----------

CREATE INDEX customers_name_i
ON co.customers
USING BTREE (full_name ASC);

CREATE INDEX inventory_product_id_i
ON co.inventory
USING BTREE (product_id ASC);

CREATE INDEX order_items_shipment_id_i
ON co.order_items
USING BTREE (shipment_id ASC);

CREATE INDEX orders_customer_id_i
ON co.orders
USING BTREE (customer_id ASC);

CREATE INDEX orders_store_id_i
ON co.orders
USING BTREE (store_id ASC);

CREATE INDEX shipments_customer_id_i
ON co.shipments
USING BTREE (customer_id ASC);

CREATE INDEX shipments_store_id_i
ON co.shipments
USING BTREE (store_id ASC);

CREATE INDEX dept_location_ix
ON hr.departments
USING BTREE (location_id ASC);

CREATE INDEX emp_department_ix
ON hr.employees
USING BTREE (department_id ASC);

CREATE INDEX emp_job_ix
ON hr.employees
USING BTREE (job_id ASC);

CREATE INDEX emp_manager_ix
ON hr.employees
USING BTREE (manager_id ASC);

CREATE INDEX emp_name_ix
ON hr.employees
USING BTREE (last_name ASC, first_name ASC);

CREATE INDEX jhist_department_ix
ON hr.job_history
USING BTREE (department_id ASC);

CREATE INDEX jhist_employee_ix
ON hr.job_history
USING BTREE (employee_id ASC);

CREATE INDEX jhist_job_ix
ON hr.job_history
USING BTREE (job_id ASC);

CREATE INDEX loc_city_ix
ON hr.locations
USING BTREE (city ASC);

CREATE INDEX loc_country_ix
ON hr.locations
USING BTREE (country_id ASC);

CREATE INDEX loc_state_province_ix
ON hr.locations
USING BTREE (state_province ASC);

-- ------------ Write CREATE-CONSTRAINT-stage scripts -----------

ALTER TABLE co.customers
ADD CONSTRAINT customers_email_u UNIQUE (email_address);

ALTER TABLE co.customers
ADD CONSTRAINT customers_pk PRIMARY KEY (customer_id);

ALTER TABLE co.inventory
ADD CONSTRAINT inventory_pk PRIMARY KEY (inventory_id);

ALTER TABLE co.inventory
ADD CONSTRAINT inventory_store_product_u UNIQUE (store_id, product_id);

ALTER TABLE co.order_items
ADD CONSTRAINT order_items_pk PRIMARY KEY (order_id, line_item_id);

ALTER TABLE co.order_items
ADD CONSTRAINT order_items_product_u UNIQUE (product_id, order_id);

ALTER TABLE co.orders
ADD CONSTRAINT orders_pk PRIMARY KEY (order_id);

ALTER TABLE co.orders
ADD CONSTRAINT orders_status_c CHECK (order_status IN ('CANCELLED', 'COMPLETE', 'OPEN', 'PAID', 'REFUNDED', 'SHIPPED'));

ALTER TABLE co.products
ADD CONSTRAINT products_pk PRIMARY KEY (product_id);

ALTER TABLE co.shipments
ADD CONSTRAINT shipment_status_c CHECK (shipment_status IN ('CREATED', 'SHIPPED', 'IN-TRANSIT', 'DELIVERED'));

ALTER TABLE co.shipments
ADD CONSTRAINT shipments_pk PRIMARY KEY (shipment_id);

ALTER TABLE co.stores
ADD CONSTRAINT store_at_least_one_address_c CHECK (web_address IS NOT NULL OR physical_address IS NOT NULL);

ALTER TABLE co.stores
ADD CONSTRAINT store_name_u UNIQUE (store_name);

ALTER TABLE co.stores
ADD CONSTRAINT stores_pk PRIMARY KEY (store_id);

ALTER TABLE hr.countries
ADD CONSTRAINT country_c_id_pk PRIMARY KEY (country_id);

ALTER TABLE hr.departments
ADD CONSTRAINT dept_id_pk PRIMARY KEY (department_id);

ALTER TABLE hr.employees
ADD CONSTRAINT emp_email_uk UNIQUE (email);

ALTER TABLE hr.employees
ADD CONSTRAINT emp_emp_id_pk PRIMARY KEY (employee_id);

ALTER TABLE hr.employees
ADD CONSTRAINT emp_salary_min CHECK (salary > 0);

ALTER TABLE hr.job_history
ADD CONSTRAINT jhist_date_interval CHECK (end_date > start_date);

ALTER TABLE hr.job_history
ADD CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date);

ALTER TABLE hr.jobs
ADD CONSTRAINT job_id_pk PRIMARY KEY (job_id);

ALTER TABLE hr.locations
ADD CONSTRAINT loc_id_pk PRIMARY KEY (location_id);

ALTER TABLE hr.regions
ADD CONSTRAINT reg_id_pk PRIMARY KEY (region_id);

ALTER TABLE hr.time_range_sales
ADD PRIMARY KEY (prod_id);

-- ------------ Write CREATE-FOREIGN-KEY-CONSTRAINT-stage scripts -----------

ALTER TABLE co.inventory
ADD CONSTRAINT inventory_product_id_fk FOREIGN KEY (product_id) 
REFERENCES co.products (product_id)
ON DELETE NO ACTION;

ALTER TABLE co.inventory
ADD CONSTRAINT inventory_store_id_fk FOREIGN KEY (store_id) 
REFERENCES co.stores (store_id)
ON DELETE NO ACTION;

ALTER TABLE co.order_items
ADD CONSTRAINT order_items_order_id_fk FOREIGN KEY (order_id) 
REFERENCES co.orders (order_id)
ON DELETE NO ACTION;

ALTER TABLE co.order_items
ADD CONSTRAINT order_items_product_id_fk FOREIGN KEY (product_id) 
REFERENCES co.products (product_id)
ON DELETE NO ACTION;

ALTER TABLE co.order_items
ADD CONSTRAINT order_items_shipment_id_fk FOREIGN KEY (shipment_id) 
REFERENCES co.shipments (shipment_id)
ON DELETE NO ACTION;

ALTER TABLE co.orders
ADD CONSTRAINT orders_customer_id_fk FOREIGN KEY (customer_id) 
REFERENCES co.customers (customer_id)
ON DELETE NO ACTION;

ALTER TABLE co.orders
ADD CONSTRAINT orders_store_id_fk FOREIGN KEY (store_id) 
REFERENCES co.stores (store_id)
ON DELETE NO ACTION;

ALTER TABLE co.shipments
ADD CONSTRAINT shipments_customer_id_fk FOREIGN KEY (customer_id) 
REFERENCES co.customers (customer_id)
ON DELETE NO ACTION;

ALTER TABLE co.shipments
ADD CONSTRAINT shipments_store_id_fk FOREIGN KEY (store_id) 
REFERENCES co.stores (store_id)
ON DELETE NO ACTION;

ALTER TABLE hr.countries
ADD CONSTRAINT countr_reg_fk FOREIGN KEY (region_id) 
REFERENCES hr.regions (region_id)
ON DELETE NO ACTION;

ALTER TABLE hr.departments
ADD CONSTRAINT dept_loc_fk FOREIGN KEY (location_id) 
REFERENCES hr.locations (location_id)
ON DELETE NO ACTION;

ALTER TABLE hr.departments
ADD CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) 
REFERENCES hr.employees (employee_id)
ON DELETE NO ACTION;

ALTER TABLE hr.employees
ADD CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) 
REFERENCES hr.departments (department_id)
ON DELETE NO ACTION;

ALTER TABLE hr.employees
ADD CONSTRAINT emp_job_fk FOREIGN KEY (job_id) 
REFERENCES hr.jobs (job_id)
ON DELETE NO ACTION;

ALTER TABLE hr.employees
ADD CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) 
REFERENCES hr.employees (employee_id)
ON DELETE NO ACTION;

ALTER TABLE hr.job_history
ADD CONSTRAINT jhist_dept_fk FOREIGN KEY (department_id) 
REFERENCES hr.departments (department_id)
ON DELETE NO ACTION;

ALTER TABLE hr.job_history
ADD CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) 
REFERENCES hr.employees (employee_id)
ON DELETE NO ACTION;

ALTER TABLE hr.job_history
ADD CONSTRAINT jhist_job_fk FOREIGN KEY (job_id) 
REFERENCES hr.jobs (job_id)
ON DELETE NO ACTION;

ALTER TABLE hr.locations
ADD CONSTRAINT loc_c_id_fk FOREIGN KEY (country_id) 
REFERENCES hr.countries (country_id)
ON DELETE NO ACTION;

-- ------------ Write CREATE-FUNCTION-stage scripts -----------

CREATE OR REPLACE FUNCTION co.customers$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.customer_id := nextval('seq_customers$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION co.inventory$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.inventory_id := nextval('seq_inventory$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION co.orders$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.order_id := nextval('seq_orders$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION co.products$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.product_id := nextval('seq_products$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION co.shipments$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.shipment_id := nextval('seq_shipments$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION co.stores$tr_fn_ind_on_null()
RETURNS trigger
AS
$BODY$
BEGIN
   New.store_id := nextval('seq_stores$def_on_null');
   RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION hr.secure_employees$employees()
RETURNS trigger
AS
$BODY$
BEGIN
    BEGIN
        /*
        [5340 - Severity CRITICAL - PostgreSQL doesn't support the HR.SECURE_DML() function. Revise your code to use another function or create a user-defined function.]
        secure_dml
        */
    END;

    IF TG_OP = 'INSERT' THEN
        RETURN NULL;
    ELSIF TG_OP = 'UPDATE' THEN
        RETURN NULL;
    ELSIF TG_OP = 'DELETE' THEN
        RETURN NULL;
    END IF;
END;
$BODY$
LANGUAGE  plpgsql;

CREATE OR REPLACE FUNCTION hr.update_job_history$employees()
RETURNS trigger
AS
$BODY$
BEGIN
    BEGIN
        /*
        [5340 - Severity CRITICAL - PostgreSQL doesn't support the HR.ADD_JOB_HISTORY(NUMBER,DATE,DATE,VARCHAR2,NUMBER) function. Revise your code to use another function or create a user-defined function.]
        add_job_history(:old.employee_id, :old.hire_date, sysdate,
                          :old.job_id, :old.department_id)
        */
    END;
    RETURN NEW;
END;
$BODY$
LANGUAGE  plpgsql;

-- ------------ Write CREATE-PROCEDURE-stage scripts -----------

CREATE OR REPLACE PROCEDURE hr.add_job_history(IN p_emp_id DOUBLE PRECISION, IN p_start_date TIMESTAMP WITHOUT TIME ZONE, IN p_end_date TIMESTAMP WITHOUT TIME ZONE, IN p_job_id TEXT, IN p_department_id DOUBLE PRECISION)
AS 
$BODY$
BEGIN
    INSERT INTO hr.job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE hr.secure_dml()
AS 
$BODY$
BEGIN
    IF aws_oracle_ext.TO_CHAR((CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0), 'HH24:MI') NOT BETWEEN '08:00' AND '18:00' OR aws_oracle_ext.TO_CHAR((CLOCK_TIMESTAMP() AT TIME ZONE COALESCE(CURRENT_SETTING('aws_oracle_ext.tz', TRUE), 'UTC'))::TIMESTAMP(0), 'DY') IN ('SAT', 'SUN') THEN
        RAISE USING hint = -20205, message = 'You may only make changes during normal office hours', detail = 'User-defined exception';
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

-- ------------ Write CREATE-TRIGGER-stage scripts -----------

CREATE TRIGGER customers$tr_ind_on_null
BEFORE INSERT
ON co.customers
FOR EACH ROW
when (New.CUSTOMER_ID is null)
EXECUTE PROCEDURE co.customers$tr_fn_ind_on_null();

CREATE TRIGGER inventory$tr_ind_on_null
BEFORE INSERT
ON co.inventory
FOR EACH ROW
when (New.INVENTORY_ID is null)
EXECUTE PROCEDURE co.inventory$tr_fn_ind_on_null();

CREATE TRIGGER orders$tr_ind_on_null
BEFORE INSERT
ON co.orders
FOR EACH ROW
when (New.ORDER_ID is null)
EXECUTE PROCEDURE co.orders$tr_fn_ind_on_null();

CREATE TRIGGER products$tr_ind_on_null
BEFORE INSERT
ON co.products
FOR EACH ROW
when (New.PRODUCT_ID is null)
EXECUTE PROCEDURE co.products$tr_fn_ind_on_null();

CREATE TRIGGER shipments$tr_ind_on_null
BEFORE INSERT
ON co.shipments
FOR EACH ROW
when (New.SHIPMENT_ID is null)
EXECUTE PROCEDURE co.shipments$tr_fn_ind_on_null();

CREATE TRIGGER stores$tr_ind_on_null
BEFORE INSERT
ON co.stores
FOR EACH ROW
when (New.STORE_ID is null)
EXECUTE PROCEDURE co.stores$tr_fn_ind_on_null();

CREATE TRIGGER secure_employees
BEFORE INSERT OR UPDATE OR DELETE
ON hr.employees
FOR EACH STATEMENT
EXECUTE PROCEDURE hr.secure_employees$employees();

CREATE TRIGGER update_job_history
AFTER UPDATE OF JOB_ID, DEPARTMENT_ID
ON hr.employees
FOR EACH ROW
EXECUTE PROCEDURE hr.update_job_history$employees();

