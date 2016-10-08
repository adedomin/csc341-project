---
title: Project 2 deliverable
abstract: |
    *This a document that will describe all the business rules and display definitions for each of the entities identified in our business, a gym.*
    *firstly, we will discuss the upper most important entities, display tables about them and talk about their sub classes and how they enhance the data model as a whole.*
    *afterwards, I will discuss the high level knowledge of the business and how these entites came about.*
    *Models of the data will be strewn across the document to enhance the understanding.*

papersize: letter
geometry: margin=2cm
fontfamily: mathpazo
fontsize: 10pt
header-includes:
- \hyphenpenalty 10000
- \usepackage{fancyhdr}
- \pagestyle{fancy}
- \fancyfoot[L]{CSC341 Project - DeDominic}
- \fancyfoot[C]{}
- \fancyfoot[R]{\thepage}
- \usepackage[x11names, rgb]{xcolor}
- \usepackage[utf8]{inputenc}
#- \twocolumn
- \author{DeDominic, Anthony\\Eastern Connecticut State University\\Willimantic, USA\\dedominica@my.easternct.edu}
---

1. Introduction
===============

The problem domain we seek to solve is organizing our knowledge of our gym business into a clear, concise data model.
THe key being to represent the core parts of our business, to enhance the experience of out customer and to get insights into what we, the gym, need to do to make it better.

1.1. Business Rules
-------------------

Like all gyms and places of business there are people.
People can be a variety of things; customers, employees and trainers.
People have full names comprised of first names and last names.
People are assigned their starting date into their record.

A person can be a customer.
A customer shares the same id as a person record.
The customer can be active or inactive if they paid their membership.
The customer record should keep track of their last payment.

A person can also be an employee.
An employee has a wage and a role.

A person can also be a trainer.
A trainer record has no specific attribute.

### 1.1.1. Customer Interactions

A customer enrolls to services of the gym.
An example of a service would be general gym membership.
This general service would have a unique code, some type of identifying string for what it is and a base cost that the enrolled customer would be responsible for.
Other services, like one-on-one personal trainer services, will have a trainer associated with it.

Services can have many customers and customers can have many services associated to them.
Customers can also use equipment, however this interaction can't be precise.

### 1.1.2. Trainer Interactions

Trainers are special employees that teach classes and can provide personal services for customers.

### 1.1.3. Inventory Management

A gym has a large amount of very valuable equipment.
It is important to keep track of it for accounting reasons, but also to ensure products are being properly maintained.

There is a general equipment definition with basic information like the brand and name of the product.
The equipment has an accounting value.
The equipment also has a date since it was bought and made available at the gym.
For simplicity, it may be helpful to include a character that identifies what type of equipment it is.

An equipment can be a weightlifting equipment.
Such equipment is special in that it is much more simpler and will likely be discarded if it were to break.
The equipment also has a special property of weight and diameter.
The weight is its weight in pounds.
The diameter is a special attribute that indicates what type plates can fit on what type of bar;
for instance an Olympic bar can only take Olympic plates (2 inches).

An equipment can be a machine.
A machine is much more expensive to purchase so it is pivotal that they be maintained and in working order.
So a machine record should contain a date since it was last maintained and when the next maintenance should be done.
A machine will likely have parts or lubricants; to find these, the product serial number should be held on record so they can be found.

### 1.1.4. Sessions and Classes

A session is a one-on-one personal training service for one customer to one personal trainer.
such services will add an additional charge for each one.

Personal trainers can teach classes. classes have a fixed time and days it is ran.

2. Key Entities
===============

There are two major entities in our model, "People" and "Equipment."
From these, most of our data model is derived.

2.1. People
-----------

As a gym we "have" many people.
People can be many things, employees, customers and personal trainers.
Below is a simple table outlining all the properties these people have in common.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
person_id   CHAR(6)     primary    The primary identifier of a person.

fisrt       VARCHAR(30) n/a        The person's first name, UTF8.

last        VARCHAR(30) n/a        The person's last name, UTF8.

phone       CHAR(11)    n/a        the full phone number.

address     VARCHAR(30) n/a        The address line.

state       CHAR(2)     n/a        The state.

city        VARCHAR(20) n/a        The city.

type        VARCHAR(1)  n/a        A char that determines if the user
                                   is an employee or customer.

since       Date        n/a        A date describing when they were a
                                   member of the gym. 

birth       Date        n/a        DOB of a user can provide which
                                   can be used to offer specials.
----------- ----------- ---------- -----------------------------------

: Person entity

### 2.1.1. Customer

A customer entity is a person who ends up using our services and pays us.
Below is the definition of a customer.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
person_id   CHAR(6)     PK/FK      The primary identifier of a
                                   customer, from person.

last_pay    Date        n/a        Indicates if this customer is up to
                                   date with their membership fees.

is_active   Boolean     n/a        Programmatically indicates if 
                                   customer is up to date with payment
                                   Determined by since field in parent
                                   and last_pay date

fees        derived     n/a        Amount derived from the formula:
                                   BASE_CHARGE + Session(s)
----------- ----------- ---------- -----------------------------------

: Customer entity

### 2.1.2. Employee

An employee entity is someone we pay to maintain and provid services to the customers through the gym.
Below is the entity.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
person_id   CHAR(6)     PK/FK      The primary identifier of a
                                   customer, from person.

wage        DECIMAL(2) n/a        amount paid per hour.

type        CHAR(1)     n/a        Determines if the user is a
                                   generic employee or a physical 
                                   therapist or trainer.
----------- ----------- ---------- -----------------------------------

: Employee entity

### 2.1.3. Trainer

A trainer is an employee that is responsible for running classes at the gym or offering one on one consulting for customers.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
person_id   CHAR(6)     PK/FK      The primary identifier of a
----------- ----------- ---------- -----------------------------------

: Trainer entity

### 2.1.4. Rules

At the end, there are people associated with the gym.
They can be divided into customers and employees.
Customers have active or inactive memberships and are expected to pay their fees on time.
Employees are people of a gym that provide services to the gym; they can also be customers as well.
Trainers are a subset of employees which can teach classes or do individual training sessions with customers.
For unique constraints, a trainer has a code which is used in other entites to ensure that only trainers are added to classes and services.

2.2. Equipment
--------------

A gym has numerous amounts of workout related equipment.
Below is an entity used to identify this equipment at a high level.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    CHAR(6)     primary    The primary identifier of the gear.

name        VARCHAR(30) n/a        name of the gear.

brand       VARCHAR(30) n/a        brand name of the gear.

type        CHAR(1)     n/a        A char that determines if the 
                                   equipment is a machine of if it is
                                   A free weight or a weightlifting
                                   component

value       DECIMAL(2)  n/a        A number describing its current
                                   estimated value to the business.

since       Date        n/a        A date describing when the gear
                                   was added to the gym.
----------- ----------- ---------- -----------------------------------

: Gym Equipment

### 2.2.1. Weightlifting Equipment

This is a subtype of equipment which describes simpler equipment involved mostly with weight training.
Examples: plates, dumbdells, 2" olympic bars.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    CHAR(6)     primary    The primary identifier of the gear.

weight      Integer     n/a        The weight of the weight equipment

type        VARCHAR(20) n/a        The type of weight product this is.
                                   e.g. plate, bar, dumbbell, etc.

diameter    Integer     n/a        For bars and plates; This describes
                                   the diameter of the hole that the
                                   plate has in its center and what
                                   plates will fit on a bar. generally
                                   should only be 2 inches. This is 
                                   null for dumbbells.
----------- ----------- ---------- -----------------------------------

: Weightlifting Equipment Entity

### 2.2.2. Machine Equipment

A subtype of equipment which describes products like treadmills and other "machine" training devices.
This also describes things like powercages and squat racks which might have more use in weightlifting.
This is a subtype because unlike weightlifting gear, machines can go "out of order," generally must be maintained frequently, can have replacement parts and various other information.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    CHAR(6)     primary    The primary identifier of the gear.

type        VARCHAR(20) n/a        The type of machine this is.
                                   e.g. treadmill, powercage, bench...

in_order    Boolean     n/a        If the machine is functioning as
                                   expected.

maintained  Date        n/a        Last maintained at this date.

serial      VARCHAR(30) n/a        Machine serial number or other 
                                   identifier to find parts for this
                                   machine.
----------- ----------- ---------- -----------------------------------

: Machine Equipment Entity

### 2.2.3. Maintenance Schedule

This table indicates which employee is expected to maintain which machine at what date.
Many machines can have many maintainers and likewise.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    CHAR(6)     PK/FK      A machine being maintained.

employee_id CHAR(6)     PK/FK      The employee maintaining this.

type        VARCHAR(20) n/a        What is being worked on.

date        Date        n/a        When the maintenance is going to 
                                   take place.
----------- ----------- ---------- -----------------------------------

: Maintenance Schedule Entity

### 2.2.4. Rules

A gym has equipment which allows it to provide services.
The gym has two splits of equipment, weightlifting and machine equipment.
Weightlifting equipment can be discarded if it breaks due to their simplistic design, low price, and construction.
However machine components are much more valuable and have more working parts which may need to be maintained and fixed, thus a much more complex entity.

3. Other Entities
=================

These are the other entities of the business.
This Describes activities and services the gym provides.

3.1. Personal Sessions
----------------------

Sessions that a customer has with a personal trainer.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
customer_id CHAR(6)     PK/FK      The primary identifier of the
                                   customer

trainer_id  CHAR(6)     PK/FK      The trainer that provides this
                                   service, if null, no trainer.

cost        DECIMAL(2) n/a        The cost this service adds to a
                                   customer's fee.

time        TIME        n/a        Time this session occurs

days        VARCHAR(7)  n/a        The days this service occurs
                                   (M)on (T)ue (W)ed (Th)ur (F)ri (S)a
----------- ----------- ---------- -----------------------------------

: Session Entity

3.2. Classes
------------

Optional classes taught by trainers at a given time and on the day(s) shown.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
trainer_id  CHAR(6)     PK/FK      The trainer that leads this class.

class_type  VARCHAR(25) PK         The class that is being taught.

time        Time        n/a        The time this class is taught at.

day         VARCHAR(7)  n/a        A string of all the days this
                                   day is taught. 6 days total.
                                   (M)on (T)ues (W)ed (Th)urs (F)ri
                                   (S)at
----------- ----------- ---------- -----------------------------------

: Class entity
