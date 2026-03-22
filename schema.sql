
    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table auctions (
        active bit not null,
        clothing_pieces integer not null,
        current_highest_bid decimal(10,2),
        expected_price decimal(10,2) not null,
        starting_price decimal(10,2) not null,
        created_at datetime(6),
        highest_bidder_id bigint,
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_id bigint not null,
        winner_id bigint,
        primary key (id)
    ) engine=InnoDB;

    create table bids (
        amount decimal(10,2) not null,
        auction_id bigint not null,
        bid_time datetime(6),
        bidder_id bigint not null,
        id bigint not null auto_increment,
        primary key (id)
    ) engine=InnoDB;

    create table browsing_history (
        id bigint not null auto_increment,
        product_id bigint not null,
        user_id bigint not null,
        viewed_at datetime(6),
        primary key (id)
    ) engine=InnoDB;

    create table cart_items (
        quantity integer not null,
        cart_id bigint not null,
        id bigint not null auto_increment,
        product_variant_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table carts (
        id bigint not null auto_increment,
        updated_at datetime(6),
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table categories (
        id bigint not null auto_increment,
        description TEXT,
        name varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table messages (
        id bigint not null auto_increment,
        receiver_id bigint not null,
        sender_id bigint not null,
        timestamp datetime(6) not null,
        content varchar(1000) not null,
        primary key (id)
    ) engine=InnoDB;

    create table order_items (
        price_at_time_of_purchase float(53) not null,
        quantity integer not null,
        id bigint not null auto_increment,
        order_id bigint not null,
        product_variant_id bigint not null,
        status enum ('DELIVERED','PENDING','PROCESSING','REFUNDED','RETURN_REQUESTED','SHIPPED') not null,
        primary key (id)
    ) engine=InnoDB;

    create table orders (
        delivery_charge float(53),
        subtotal float(53),
        total_amount float(53),
        created_at datetime(6),
        id bigint not null auto_increment,
        user_id bigint not null,
        order_status varchar(255) not null,
        shipping_address varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table otps (
        verified bit not null,
        expires_at datetime(6) not null,
        id bigint not null auto_increment,
        code varchar(255) not null,
        phone varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table product_images (
        product_id bigint not null,
        image_url varchar(255)
    ) engine=InnoDB;

    create table product_variants (
        price_modifier float(53),
        stock_quantity integer not null,
        id bigint not null auto_increment,
        product_id bigint not null,
        color varchar(255) not null,
        size varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table products (
        base_price float(53) not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        seller_id bigint,
        updated_at datetime(6),
        category varchar(255),
        description TEXT,
        main_image_url varchar(255),
        title varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        created_at datetime(6),
        id bigint not null auto_increment,
        order_id bigint not null,
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        description TEXT,
        reason varchar(255) not null,
        status varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table reviews (
        rating integer not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        product_id bigint not null,
        seller_replied_at datetime(6),
        user_id bigint not null,
        comment TEXT,
        seller_reply TEXT,
        primary key (id)
    ) engine=InnoDB;

    create table store_policies (
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        content TEXT not null,
        topic varchar(255) not null,
        primary key (id)
    ) engine=InnoDB;

    create table users (
        enabled bit not null,
        created_at datetime(6),
        id bigint not null auto_increment,
        updated_at datetime(6),
        email varchar(255) not null,
        name varchar(255) not null,
        password varchar(255),
        phone varchar(255),
        provider enum ('GOOGLE','LOCAL') not null,
        role enum ('ADMIN','SELLER','USER') not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlist_items (
        id bigint not null auto_increment,
        product_id bigint not null,
        wishlist_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table wishlists (
        id bigint not null auto_increment,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table carts 
       add constraint UK64t7ox312pqal3p7fg9o503c2 unique (user_id);

    alter table categories 
       add constraint UKt8o6pivur7nn124jehx7cygw5 unique (name);

    alter table store_policies 
       add constraint UK3ikk9pdgoijxltr9rncdjprj1 unique (topic);

    alter table users 
       add constraint UK6dotkott2kjsp8vw4d0m25fb7 unique (email);

    alter table wishlists 
       add constraint UKobh8c909a28dx3aqh4cbdhh25 unique (user_id);

    alter table auctions 
       add constraint FKsm69yfvrufm9bx7p1c79jne0p 
       foreign key (highest_bidder_id) 
       references users (id);

    alter table auctions 
       add constraint FK5o1kpvuu8n7sgxm5cpb6fvbxo 
       foreign key (product_id) 
       references products (id);

    alter table auctions 
       add constraint FKlu950hyc1m3wi2km1mlrcttw1 
       foreign key (seller_id) 
       references users (id);

    alter table auctions 
       add constraint FKgueiqsr3d7x8kgdfva3ul8km2 
       foreign key (winner_id) 
       references users (id);

    alter table bids 
       add constraint FKbm89m2gow82dotpnlcp7t3p5f 
       foreign key (auction_id) 
       references auctions (id);

    alter table bids 
       add constraint FKmtrc6tnwawlpk1u2km6qnxbha 
       foreign key (bidder_id) 
       references users (id);

    alter table browsing_history 
       add constraint FKiv8qa9i40ql2c2nxbdi1laxwn 
       foreign key (product_id) 
       references products (id);

    alter table browsing_history 
       add constraint FK184u59dw6surr7a7w5pe7exh9 
       foreign key (user_id) 
       references users (id);

    alter table cart_items 
       add constraint FKpcttvuq4mxppo8sxggjtn5i2c 
       foreign key (cart_id) 
       references carts (id);

    alter table cart_items 
       add constraint FKn1s4l7h0vm4o259wpu7ft0y2y 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table carts 
       add constraint FKb5o626f86h46m4s7ms6ginnop 
       foreign key (user_id) 
       references users (id);

    alter table messages 
       add constraint FKt05r0b6n0iis8u7dfna4xdh73 
       foreign key (receiver_id) 
       references users (id);

    alter table messages 
       add constraint FK4ui4nnwntodh6wjvck53dbk9m 
       foreign key (sender_id) 
       references users (id);

    alter table order_items 
       add constraint FKbioxgbv59vetrxe0ejfubep1w 
       foreign key (order_id) 
       references orders (id);

    alter table order_items 
       add constraint FKltmtlue0wixrg1cf0xo7x0l4d 
       foreign key (product_variant_id) 
       references product_variants (id) 
       on delete cascade;

    alter table orders 
       add constraint FK32ql8ubntj5uh44ph9659tiih 
       foreign key (user_id) 
       references users (id);

    alter table product_images 
       add constraint FKqnq71xsohugpqwf3c9gxmsuy 
       foreign key (product_id) 
       references products (id);

    alter table product_variants 
       add constraint FKosqitn4s405cynmhb87lkvuau 
       foreign key (product_id) 
       references products (id) 
       on delete cascade;

    alter table products 
       add constraint FKbgw3lyxhsml3kfqnfr45o0vbj 
       foreign key (seller_id) 
       references users (id);

    alter table reports 
       add constraint FKk5dthqrkm8y8yyb86e9ob538u 
       foreign key (reported_seller_id) 
       references users (id);

    alter table reports 
       add constraint FKd3qiw2om5d2oh5xb7fbdcq225 
       foreign key (reporter_id) 
       references users (id);

    alter table reviews 
       add constraint FKpl51cejpw4gy5swfar8br9ngi 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FKcgy7qjc1r99dp117y9en6lxye 
       foreign key (user_id) 
       references users (id);

    alter table wishlist_items 
       add constraint FKqxj7lncd242b59fb78rqegyxj 
       foreign key (product_id) 
       references products (id);

    alter table wishlist_items 
       add constraint FKkem9l8vd14pk3cc4elnpl0n00 
       foreign key (wishlist_id) 
       references wishlists (id);

    alter table wishlists 
       add constraint FK330pyw2el06fn5g28ypyljt16 
       foreign key (user_id) 
       references users (id);

    create table reviews (
        id bigint not null auto_increment,
        comment TEXT not null,
        rating integer not null,
        seller_reply TEXT,
        created_at datetime(6),
        product_id bigint not null,
        user_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    create table reports (
        id bigint not null auto_increment,
        description TEXT,
        order_id bigint not null,
        reason varchar(255) not null,
        status varchar(255) not null default 'PENDING',
        created_at datetime(6),
        reported_seller_id bigint not null,
        reporter_id bigint not null,
        primary key (id)
    ) engine=InnoDB;

    alter table reviews 
       add constraint FK_reviews_product 
       foreign key (product_id) 
       references products (id);

    alter table reviews 
       add constraint FK_reviews_user 
       foreign key (user_id) 
       references users (id);

    alter table reports 
       add constraint FK_reports_reporter 
       foreign key (reporter_id) 
       references users (id);

    alter table reports 
       add constraint FK_reports_seller 
       foreign key (reported_seller_id) 
       references users (id);
