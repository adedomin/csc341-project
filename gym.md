---
title: Project 2 deliverable
abstract: |
    *This a document that will describe all the business rules and display definitions for each of the entities identified in our business, a gym.*
    *firstly, we will discuss the upper most important entities, display tables about them and talk about their sub classes and how they enhance the data model as a whole.*
    *afterwards, I will discuss the high level knowledge of the business and how these entites came about.*
    *Models of the data will be strewn across the document to enhance the understanding.*
    *For detailed and summarized revision history, please see: <https://github.com/adedomin/csc341-project/commits/master>*

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
This data model should represent the core parts of our business, to enhance the experience of out customers and to get insights into what we, the gym, need to do to make it better.

1.1. Example Use Cases[^1]
----------------------

[^1]: please see ./sql/gym-questions.sql for implementations of qustions and their answers using test data.

  * The sales and retention team want to know all the phone numbers and names of inactive users
  * How many machines are available for the upcoming spin class (cycle machines)?
  * Check to see if a classes conflicts with personal trainer sessions.
  * Check to ensure that personal trainer sessions do not conflict.
  * Get total expected monthly amount from each customer, apply birthday discount for people with birthdays this month.
  * Use above to derive total expected amount for this month.
  * The database should show employees what machines they are responsible for.
  * The database should allow us to track broken down machines and to make sure they have maintenance scheduled.
  * The database should help us to make equipment purchasing decisions based on number of these equipments; for instance: make sure there are at least 10 plates to one weightlifting bar.
  * The database should help us to find parts for broken machines, by finding them and returning a serial number to look up.
  * The database should retain personal information for billing, handing out promotional offerings, etc.

1.2. Business Rules
-------------------

Like all gyms and places of business, there are people.
People can be a variety of things; customers, employees and trainers.
People have full names comprised of first names and last names.
People are assigned their starting date (as member_since) into their record.

A person can be a customer.
A customer shares the same id as a person record.
The customer can be active or inactive if they paid their membership.
The customer record should keep track of their last payment.

A person can also be an employee.
An employee has a wage and a role.

A person can also be a trainer.
A trainer record has no specific--special, attribute.

### 1.2.1. Customer Interactions

A customer enrolls to services of the gym (a fee, see 3.1.). An example of a service would be general gym membership. This general service would have a unique code, some type of identifying string for what it is and a base cost that the enrolled customer would be responsible for. Other services, like one-on-one personal trainer services, will have a trainer associated with it.

Fees can have many customers and customers can have many Fees associated to them (see 3.2.). Customers can also use equipment, however this interaction can't be precise.

### 1.2.2. Trainer Interactions

Trainers are special employees that teach classes and can provide personal services for customers.

### 1.2.3. Inventory Management

A gym has a large amount of high value equipment.
It is important to keep track of it for accounting reasons, but also to ensure products are being properly maintained.

There is a general equipment definition with basic information like the brand and name of the product.
The equipment has an inventory value.
The equipment also has a date, which indicates when it was bought and made available at the gym.
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

### 1.2.4. Sessions and Classes

A session is a one-on-one personal training service for one customer to one personal trainer.
Such services will add an additional charge for each one.

Personal trainers can teach classes. Classes have a fixed time and days it is ran; however, they are a free service to the members.

### 1.2.5. Data retention and Integrity Policies

Data is assumed to be incrementally backed up.
Thus it is safe to assume cascading deletes are fine.
Future database designs can take into account versioning mechanisms to ensure data integrity.

Cascading deletes are specified because it's assumed when a user leaves and wants to be removed from our person's list, their data should not be persisted. It is more likely customer or employee entries would be removed before a person entity is.
Thus cascading deletes should not apply in many cases.

On fields likes CustomerFees, it's generally assumed if a customer is removed, then it should automatically remove all traces of payment from the system, thus the cascading delete policy.

Equipment that is thrown away should automatically clean up its subclass tables, thus cascading deletes.
These tables shouldn't even be touched directly.

2. Key Entities
===============

Before going into the data, please keep in mind these virtual types.
They must equal the values in the constraint column.

name  actual       constraints
----- ------------ ------------------
BOOL  CHAR(1)      'Y' OR 'Y'
PTYPE CHAR(1)      'R' OR 'E' 
ETYPE CHAR(1)      'W' OR 'M'
TIME  NUMERIC(4,0) 2400 > TIME > 0

There are two major entities in our model, "People" and "Equipment."
From these, most of our data model is derived.

2.1. People
-----------

As a gym we "have" many people.
People can be many things, employees, customers and personal trainers.
Below is a simple table outlining all the properties these people have in common.

------------ ----------- ---------- -----------------------------------
column name  type        typeof key description
------------ ----------- ---------- -----------------------------------
person_id    NUMERIC(10) PK         The primary identifier of a person.

first_name   VARCHAR(30) n/a        The person's first name, UTF8.

last_name    VARCHAR(30) n/a        The person's last name, UTF8.

phone        CHAR(11)    n/a        the full phone number.

address      VARCHAR(69) n/a        The address line.

state        CHAR(2)     n/a        The state. Assumed 'CT' if left out

city         VARCHAR(20) n/a        The city.

person_type  PTYPE       n/a        A char that determines if the user
                                    is an employee or customer.

member_since Date        n/a        A date describing when they were a
                                    member of the gym. 

birth_date   Date        n/a        DOB of a user can provide which
                                    can be used to offer specials.
------------ ----------- ---------- -----------------------------------

: Person entity

### 2.1.1. Customer

A customer entity is a person who pays to consume servies offered by the gym.
Below is the definition of a customer.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
customer_id NUMERIC(10) PK/FK      The primary identifier of a
                                   customer, from person.

last_paymet Date        n/a        Indicates if this customer is up to
                                   date with their membership fees.

is_active   BOOL        n/a        Programmatically indicates if 
                                   customer is up to date with payment
                                   Determined by since field in parent
                                   and last_pay date. Customers newly
                                   enrolled should be assumed to be
                                   Active on creation unless specified
----------- ----------- ---------- -----------------------------------

: Customer entity

### 2.1.2. Employee

An employee entity is someone we pay to maintain and provid services to the customers through the gym.
Below is the entity.

----------- ------------ ---------- -----------------------------------
column name type         typeof key description
----------- ------------ ---------- -----------------------------------
employee_id NUMERIC(10)  PK/FK      The primary identifier of a
                                    customer, from person.
                         
wage        NUMERIC(5,2) n/a        amount paid per hour.
                         
is_trainer  BOOL         n/a        Determines if the user is a
                                    generic employee or a physical 
                                    therapist or trainer. should be 
                                    false by default.
----------- ------------ ---------- -----------------------------------

: Employee entity

### 2.1.3. Trainer

A trainer is an employee that is responsible for running classes at the gym or offering one on one consulting for customers.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
trainer_id  NUMERIC(10) PK/FK      The primary identifier of a
----------- ----------- ---------- -----------------------------------

: Trainer entity

### 2.1.4. Rules

At the end, there are people associated with the gym.
They can be divided into customers and employees.
Customers have active or inactive memberships and are expected to pay their fees on time.
Employees are people of a gym that provide services to the gym; employees, as a benefit of their employment are provided basic membership for free.
Trainers are a subset of employees which can teach classes or do individual training sessions with customers.
For unique constraints, a trainer has a code which is used in other entites to ensure that only trainers are added to classes and services.

2.2. Equipment
--------------

A gym has numerous amounts of workout related equipment.
Below is an entity used to identify this equipment at a high level.

------------ ------------ ---------- -----------------------------------
column name  type         typeof key description
------------ ------------ ---------- -----------------------------------
equip_id     NUMERIC(10)  PK         The primary identifier of the gear.

name         VARCHAR(30)  n/a        name of the gear.

brand        VARCHAR(30)  n/a        brand name of the gear.

equip_type   ETYPE        n/a        A char that determines if the 
                                     equipment is a machine of if it is
                                     A free weight or a weightlifting
                                     component

value        NUMERIC(7,2) n/a        A number describing its current
                                     estimated value to the business.

purchased_at Date         n/a        A date describing when the gear
                                     was added to the gym.
------------ ------------ ---------- -----------------------------------

: Gym Equipment

### 2.2.1. Weightlifting Equipment

This is a subtype of equipment which describes simpler equipment involved mostly with weight training.
Examples: plates, dumbdells, 2" olympic bars.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    NUMERIC(10) PK         The primary identifier of the gear.

weight      NUMERIC(3)  n/a        The weight of the weight equipment.
                                   Weight is in Imperial lbs.

weight_type VARCHAR(20) n/a        The type of weight product this is.
                                   e.g. plate, bar, dumbbell, etc.

diameter    NUMERIC(2)  n/a        For bars and plates; This describes
                                   the diameter of the hole that the
                                   plate has in its center and what
                                   plates will fit on a bar. generally
                                   should only be 2 inches. This is 
                                   null for dumbbells or other.
----------- ----------- ---------- -----------------------------------

: Weightlifting Equipment Entity

### 2.2.2. Machine Equipment

A subtype of equipment which describes products like treadmills and other "machine" training devices.
This also describes things like powercages and squat racks which might have more use in weightlifting.
This is a subtype because unlike weightlifting gear, machines can go "out of order," generally must be maintained frequently, can have replacement parts and various other information.

------------ ----------- ---------- -----------------------------------
column name  type        typeof key description
------------ ----------- ---------- -----------------------------------
equip_id     NUMERIC(10) PK         The primary identifier of the gear.

machine_type VARCHAR(20) n/a        The type of machine this is.
                                    e.g. treadmill, powercage, bench...

in_order     BOOL        n/a        If the machine is functioning as
                                    expected. Assumed true on entry,
                                    unless specified otherwise.

maintained   Date        n/a        Last maintained at this date.

serial       VARCHAR(30) n/a        Machine serial number or other 
                                    identifier to find parts for this
                                    machine.
------------ ----------- ---------- -----------------------------------

: Machine Equipment Entity

### 2.2.3. Maintenance Schedule

This table indicates which employee is expected to maintain which machine at what date.
Many machines can have many maintainers and likewise.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
equip_id    NUMERIC(10) PK/FK      A machine being maintained.

employee_id NUMERIC(10) PK/FK      The employee maintaining this.

needs_work  VARCHAR(50) n/a        What is being worked on.

work_date   Date        n/a        When the maintenance is going to 
                                   take place.
----------- ----------- ---------- -----------------------------------

: Maintenance Schedule Entity

### 2.2.4. Rules

A gym has equipment which allows it to provide services.
The gym has two major types of equipment: weightlifting and machine equipment.
Weightlifting equipment can be discarded if it breaks due to their simplistic design, low price, and construction.
However machine components are much more valuable and have more working parts which may need to be maintained and fixed, thus a much more complex entity.

3. Other Entities
=================

These are the other entities of the business.
This Describes activities and services the gym provides.

3.1 Fees
--------

This is an entity that contains a cost to a customer (or discount) and a short description describing what it's for.

So, for instance, consider a promotional gym membership discount, one would indicate that it is a promotional and set a negative value for the fee.

----------- ------------ ---------- -----------------------------------
column name type         typeof key description
----------- ------------ ---------- -----------------------------------
fee_id      NUMERIC(10)  PK         An id referring to this fee.

fee_amount  NUMERIC(5,2) n/a        The cost or discount for this fee

fee_desc    VARCHAR(50)  n/a        A short description of the fee
                                    e.g. "General Membership"
----------- ------------ ---------- -----------------------------------

3.2. CustomerFees
-----------------

A junction table which links fees to customers.

----------- ------------ ---------- -----------------------------------
column name type         typeof key description
----------- ------------ ---------- -----------------------------------
fee_id      NUMERIC(10)  PK/FK      The fee

customer_id NUMERIC(10)  PK/FK      The customer
----------- ------------ ---------- -----------------------------------

3.3. Personal Sessions
----------------------

Sessions that a customer has with a personal trainer, or base membership if trainer is not set.

----------- ------------ ---------- -----------------------------------
column name type         typeof key description
----------- ------------ ---------- -----------------------------------
customer_id NUMERIC(10)  PK/FK      The primary identifier of the
                                    customer

trainer_id  NUMERIC(10)  PK/FK      The trainer that provides this
                                    service, if null, no trainer.

fee_id      NUMERIC(10)  FK         The fee attached tot his service.

time        TIME         n/a        Time this session occurs

days        VARCHAR(7)   n/a        The days this service occurs
                                    (M)on (T)ue (W)ed Thu(r) (F)ri (S)a
----------- ------------ ---------- -----------------------------------

: Session Entity

3.4. Classes
------------

Optional classes taught by trainers at a given time and on the day(s) shown.

----------- ----------- ---------- -----------------------------------
column name type        typeof key description
----------- ----------- ---------- -----------------------------------
trainer_id  NUMERIC(10) PK/FK      The trainer that leads this class.

class_name  VARCHAR(25) PK         The class that is being taught.

time        TIME        n/a        The time this class is taught at.

days        CHAR(7)     n/a        string of days the class is taught
                                   on. e.g. for every day of the week:
                                   mtwrf (r = thursday)
----------- ----------- ---------- -----------------------------------

: Class entity
