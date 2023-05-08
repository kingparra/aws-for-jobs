*********************
 Database vocabulary
*********************
This is an attempt to fill myself in on basic database vocabulary.

Theses notes come from wikipedia, my personal
experience with lambda calculus, the videos 
from CMU Intro to Database Systems `here 
<https://www.youtube.com/
playlist?list=PLSE8ODhjZXjaKScG3l0nuOiDTTqpfnWFf>`_
and `this course on SQL <https://www.masterywithsql.com/>`_.


What is a database?
-------------------
Database

  Organized collection of interrelated data that models
  some aspect of the real world.


Tools
-----
Database Management System (DBMS)

  Software used to interact with and manage the DB.

  A general-purpose DBMS supports the definition,
  creation, querying, update, and administration
  of databases in accordance with some data model.

Data Manipulation Language (DML)

  Procedural: Specifies the high-level strategy to find
  the desired result based on sets / bags.

  Non-procedural (declarative): The query specifies
  only what data is wanted and not how to find it.

Structured Query Language (SQL)


Tables, Rows, Columns and Cells
-------------------------------
Table

  A structure that organizes data into rows and
  columns, forming a grid. A table has a specified
  number of columns, but can have any number of rows.

  (Table == Relation).
  (Row == Record == Tuple).
  (Column == Attribute).
  (Cell == Field).

  See the definition for relational algebra for more.


Keys and their categories
-------------------------
Key

  A key is just a column that is used to sort records.

  There are many classifications of keys based on how
  they are used, or what kind of data is allowed in the
  column, but that's the basic idea.

Primary Key

  A column (or multiple columns) that contains unique values 
  that are used to identify a row. Each value is unique within 
  the table and cannot be null.

Foreign Key

  A key that comes from another table. Foreign keys are a
  mechanism for associating tables with each other.


Theory
------
ACID

CRUD

Referential Integrity

Data independence

  Databases used to have tight coupling between what
  the database looked like logically and the on-disk
  machine implementation. The lookup path was dependent
  on the data structure implementation.

Schema

  A description of a particular collection of data,
  using a given data model. 

Data Model

  A data model is a collection of concepts for
  describing the data in a database.

  Relational

  Key/value, Graph, Document/Object, Wide-column/Column-family

Relational Model

  The relational model was introduced in the paper
  "A relational model of data for large shared data 
  banks" by E. F. Codd in June 1970. 
  https://dl.acm.org/doi/10.1145/362384.362685

  (Which is a follow up of a paper published in 1969
  named "Derivability, redundancy and consistency of
  relations stored in large data banks".
  https://dl.acm.org/doi/10.1145/1558334.1558336)

  A model is an abstract description of a physical
  system (using a formal language, or mathematical
  techniques).

  The relational model defines a database abstraction
  based on relations to avoid maintenance overhead.

  Key tenets:

  * Store DB in simple data structures (relations).

  * Physical storage left up to the DBMS implementation.

  * Access data through high-level language, DBMS figures
    out best execution strategy.

  The relational model has three parts:

  * Structure: The definition of the databases
    relations and their contents.

  * Integrity: Ensure the databases contents satisfy constraints.

  * Manipulation: Programming interface for accessing
    and modifying a databases contents.

Algebra (abstract algebra)

  An algebra is just a notation with rewrite rules.
  You can think of it as a simple game with
  well-defined rules. Elements of the algebra don't
  have any intrinsic meaning, but meaning can be
  ascribed to them.

  Mathematicians use algebras and their ascribed
  meanings to predict the outcome of interactions
  between things. This is a mathematical model.

Normalization

  My first exposure to the term normalization comes
  from the lambda calculus, which is an abstract
  rewrite system.

  In abstract rewriting systems an expression is in
  normal form if it cannot be rewritten any further
  using the rewrite rule under consideration.

  The idea of normalization is to take something and
  reduce it to its simplest form. This helps make the
  representation of the expression as compact as possible.

  https://en.wikipedia.org/wiki/Normal_form_(abstract_rewriting)

  Databases do this, too. The aim is to reduce data
  redundancy and improve data integrity.

  https://hackr.io/blog/dbms-normalization

  https://en.wikipedia.org/wiki/Database_normalization

Tuple (in mathematics)

  A tuple is an ordered sequence of elements with a fixed length.

  https://en.wikipedia.org/wiki/Tuple

Relational Algebra

  Relational algebra is the theoretical basis for
  relational databases.

  The data types of relational algebra are:

  * **Relation**: A relation is a table or a set of
    tuples, where each tuple represents a row in the
    table. Each tuple consists of one or more
    attributes, where each attribute represents a
    column in the table.

  * **Attribute**: An attribute is a named column in a
    relation, which specifies the type of values that
    can be stored in that column. The type of a column
    can be (but is not limited to): integer, float,
    character, or string.

  * **Tuple**: A tuple is a row in a relation, which
    consists of a set of attribute values.

  * **Domain**: A domain is the set of all possible
    values for a given attribute.

  * **Null**: Null is a special value that represents
    the absence of a value. A null value can be
    assigned to any attribute in a tuple.

  Operations of relational algebra:

  * **Selection** (σ): Selects a subset of rows from a
    relation (table) that satisfy a specified condition.

  * **Projection** (π): Selects a subset of columns
    (attributes) from a relation. (In math a projection
    is an idempotent mapping of a set into a subset.)

  * **Union** (∪): Combines two relations (tables) with
    the same schema (column headings) into a single
    relation with all the rows (tuples) from both.

  * **Intersection** (∩): Computes the set of all rows
    (tuples) that are in both of two relations.

  * **Difference** (−): Computes the set of all rows
    (tuples) that are in one relation but not in another.

  * **Cartesian** product (×): Produces a relation that
    combines each row (tuple) of the first relation with each
    row (tuple) of the second relation.

  * **Join** (⋈): Combines two relations (tables) 
    based on a common attribute (column) to create a
    new relation that contains all columns (attributes)
    from both relations.

    (Combine all the columns of two tables based on a
    common column.)

  * **Natural join** (⨝ ): Combine two relations based
    on their common attributes, returning a relation
    that contains only those tuples that match on those
    attributes.

  * **Rename** (ρ): Renames the columns of a relation.
