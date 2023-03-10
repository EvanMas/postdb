INSERT INTO city
VALUES (1, 'North'),
       (2, 'East'),
       (3, 'South'),
       (4, 'West');

INSERT INTO tariffs
VALUES (1, 'Based', 100, NULL, 500),
       (2, 'Faster', 200, NULL, 750),
       (3, 'Based+', 100, 1, 800),
       (4, 'Ultra full top for your money', 200, 1, 950),
       (5, 'Only TV', NULL, 1, 500),
       (6, 'Connection', NULL, NULL, 1500);

INSERT INTO customers(custid, first_name, last_name, district, phone, email, join_time, tariff)
VALUES (1, 'Ivan', 'Ivanov', 1, '9884562122', 'bigivan@mail.com', current_timestamp, 1),
       (2, 'Smith', 'Tracy', 1, '9205555555', NULL, current_timestamp, 1),
       (3, 'Rownam', 'Tim', 2, '9882220101', NULL, current_timestamp, 3),
       (4, 'Joplette', 'Janice', 4, '9209424710', 'jj@mail.com', current_timestamp, 2),
       (5, 'Butters', 'Gerald', 4, '9880784130', 'geralk@mail.com', current_timestamp, 2),
       (6, 'Tracy', 'Burton', 4, '9883549973', NULL, current_timestamp, 1),
       (7, 'Dare', 'Nancy', 1, '9887764001', 'dareands@mail.com', current_timestamp, 1),
       (8, 'Boothe', 'Tim', 4, '9204332547', 'asdfg@mail.com', current_timestamp, 2),
       (9, 'Stibbons', 'Ponder', 3, '9201603900', 'llloe@mail.com', current_timestamp, 4),
       (10, 'Owen', 'Charles', 3, '9885425251', 'Oven@mail.com', current_timestamp, 4),
       (11, 'Jones', 'David', 1, '9885368036', 'David111@mail.com', current_timestamp, 2),
       (12, 'Baker', 'Anne', 1, '9880765141', 'Annaofnumber1@mail.com', current_timestamp, 1),
       (13, 'Farrell', 'Jemima', 2, '9880160163', NULL, current_timestamp, 2),
       (14, 'Smith', 'Jack', 2, '9881633254', 'parrot@mail.com', current_timestamp, 3),
       (15, 'Bader', 'Florence', 3, '9204993527', 'ital@mail.com', current_timestamp, 2),
       (16, 'Baker', 'Timothy', 3, '9209410824', 'timoty@mail.com', current_timestamp, 2),
       (17, 'Pinker', 'David', 2, '9204096734', 'David112@mail.com', current_timestamp, 1),
       (18, 'Genting', 'Matthew', 2, '9889721377', NULL, current_timestamp, 4),
       (19, 'Mackenzie', 'Anna', 4, '9886612898', NULL, current_timestamp, 2),
       (20, 'Coplin', 'Joan', 3, '9204992232', NULL, current_timestamp, 3),
       (21, 'Sarwin', 'Ramnaresh', 4, '9204131470', 'rammstein@mail.com', current_timestamp, 2),
       (22, 'Jones', 'Douglas', 1, '9885367036', 'lol@mail.com', current_timestamp, 1),
       (23, 'Rumney', 'Henrietta', 3, '9209898876', 'lol696@mail.com', current_timestamp, 2),
       (24, 'Farrell', 'David', 2, '9887559876', NULL, current_timestamp, 3),
       (25, 'Worthington', 'Smyth', 1, '9208943758', 'blanc9@mail.com', current_timestamp, 2),
       (26, 'Purview', 'Millicent', 2, '9889419786', 'Foo2107@mail.com', current_timestamp, 3);