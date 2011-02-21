PRAGMA foreign_keys = ON;
CREATE TABLE user (
	id				INTEGER PRIMARY KEY,
	name 			char(32) NOT NULL,
	surname			char(32) NOT NULL,
	username		char(32) NOT NULL,
	password		char(64) NOT NULL,
	address			char(64),
	city			char(32),
	province_state	char(32),
	postal_code		char(10)
);

CREATE TABLE handel_order (
	user_id 		INTEGER REFERENCES user(id),
	order_number	varchar(36),
	PRIMARY KEY (user_id, order_number)
);

CREATE TABLE role (
	id				INTEGER PRIMARY KEY,
	description		TEXT
);

CREATE TABLE has_right_to (
	user_id 	INTEGER REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
	role_id		INTEGER REFERENCES role(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (user_id, role_id)
);

CREATE TABLE table_order (
	id			INTEGER PRIMARY KEY,
	date		DATETIME,
	amount_paid	MONEY
);

CREATE TABLE recipe (
	id			INTEGER PRIMARY KEY,
	description	TEXT
);

CREATE TABLE uses (
	recipe_id	INTEGER REFERENCES recipe(id),
	product_id	INTEGER REFERENCES product(id),
	PRIMARY KEY (recipe_id, product_id)
);

CREATE TABLE product_batch (
	id			INTEGER PRIMARY KEY
);

CREATE TABLE orders (
	id		INTEGER PRIMARY KEY,
	number	varchar(20)
);

CREATE TABLE orders_item (
	order_id	INTEGER REFERENCES orders(id),
	item		CHAR(64),
	PRIMARY KEY (order_id, item)
);

CREATE TABLE machine (
	id				INTEGER PRIMARY KEY,
	name			char(32) NOT NULL,
	address			char(64),
	city			char(32),
	province_state	char(32),
	postal_code		char(10),
	latitude		char(32),
	longitude		char(32)
);

CREATE TABLE machine_product (
	id				INTEGER PRIMARY KEY,
	name			char(32),
	description		TEXT,
	price			MONEY,
	duration		DATE,
	qty				INTEGER
);

CREATE TABLE product_contained (
	machine_id	INTEGER REFERENCES machine(id),
	product_id	INTEGER REFERENCES machine_product(id),
	PRIMARY KEY (machine_id, product_id)
);

CREATE TABLE product (
	id				INTEGER PRIMARY KEY,
	name			char(64),
	description		TEXT,
	price			MONEY,
	duration		DATE,
	stock_qty		INTEGER,
	stock_threshold	INTEGER
);

CREATE TABLE contains (
	product_id	INTEGER UNIQUE REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE,
	batch_id	INTEGER REFERENCES product_batch(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (product_id, batch_id)
);

CREATE TABLE producer (
	id				INTEGER PRIMARY KEY,
	name			char(32) NOT NULL,
	address			char(64),
	city			char(32),
	province_state	char(32),
	postal_code		char(10),
	email			char(64)
);

CREATE TABLE produces (
	product_id	INTEGER UNIQUE REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE,
	producer_id	INTEGER REFERENCES producer(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(product_id, producer_id)
);

CREATE TABLE product_offer (
	id		INTEGER PRIMARY KEY,
	price	MONEY
);

CREATE TABLE has_a (
	product_id			INTEGER UNIQUE REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE,
	product_offer_id	INTEGER UNIQUE REFERENCES product_offer(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (product_id, product_offer_id)
);

CREATE TABLE tag (
	id			INTEGER PRIMARY KEY,
	description	TEXT
);

CREATE TABLE product_tag (
	tag_id		INTEGER REFERENCES tag(id) ON DELETE CASCADE ON UPDATE CASCADE,
	product_id	INTEGER REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (tag_id, product_id)
);
