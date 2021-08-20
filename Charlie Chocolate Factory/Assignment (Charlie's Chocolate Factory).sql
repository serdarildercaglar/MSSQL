create database Manufacturer;
use Manufacturer;

create table Product
(
Prod_id int,
Prod_name varchar(max),
quantitiy int
primary key (Prod_id)
);


create table Component
(
comp_id int primary key,
comp_name varchar(max),
[description] varchar(max),
quantity int
);


create table supplier
(
supp_id int primary key,
supp_name varchar(max),
is_active BIT,
);

create table receipt
(
prod_id int,
comp_id int
primary key (prod_id, comp_id),
foreign key (prod_id) references product (prod_id)
);

create table prod_comp
(
prod_id int,
comp_id int
primary key (prod_id, comp_id),
foreign key (prod_id) references product (prod_id),
foreign key (comp_id) references component (comp_id)
);


create table comp_supp
(
comp_id int,
supp_id int,
order_date date,
order_quantity int,
primary key (comp_id, supp_id),
foreign key (supp_id) references supplier (supp_id),
foreign key (comp_id) references component (comp_id)
);

