PRAGMA foreign_keys = ON;
CREATE TABLE user (
	id				INTEGER PRIMARY KEY,
	name 			char(32) NOT NULL,
	surname			char(32) NOT NULL,
	password		char(64) NOT NULL,
	address			char(64),
	city			char(32),
	province_state	char(32),
	postal_code		char(10)
);

CREATE TABLE role (
	id				INTEGER PRIMARY KEY,
	description		TEXT
);

CREATE TABLE user_role (
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

CREATE TABLE product_batch (
	id			INTEGER PRIMARY KEY
);

CREATE TABLE orders (
	user_id		INTEGER REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE,
	order_id	INTEGER REFERENCES table_order(id) ON DELETE CASCADE ON UPDATE CASCADE,
	recipe_id	INTEGER REFERENCES recipe(id) ON DELETE CASCADE ON UPDATE CASCADE,
	batch_id	INTEGER UNIQUE REFERENCES product_batch(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (user_id, order_id)
);

CREATE TABLE machine (
	id				PRIMARY KEY,
	name			char(32) NOT NULL,
	address			char(64),
	city			char(32),
	province_state	char(32),
	postal_code		char(10),
	IP_address		char(16)
);

CREATE TABLE machine_product (
	machine_id	INTEGER REFERENCES machine(id) ON DELETE CASCADE ON UPDATE CASCADE,
	batch_id	INTEGER REFERENCES product_batch(id) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY (machine_id, batch_id)
);

CREATE TABLE product (
	id			INTEGER PRIMARY KEY,
	description	TEXT,
	price		MONEY,
	duration	DATE
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
