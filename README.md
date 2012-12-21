PalindromicGen
==============

Introduction
------------

PalindromicGen is a lightweight configurable tool to perform <i>reverse-and-add</i> operations to obtain Palindromic numbers. The main purpose of this application is to examine the existence of [Lychrel numbers](http://mathworld.wolfram.com/196-Algorithm.html) in a series of natural numbers.

This tool is developed using [Free Pascal](http://www.freepascal.org) compiler and its design to work with many platforms with minor adjustments. We test this tool in several Windows and Linux distributions. PalindromicGen is design to work with Pentium 4 (or compatible) instruction sets (under the default compiler configuration) and its performance is heavily depends on its settings and system configuration.

Under the theoretical limits this application can manipulate 2<sup>31</sup> digit numbers and at the development phase we test this system with maximum of 501 digits (to obtain the palindromic number of [1186060307891929990](http://www.jasondoucette.com/pal/1186060307891929990)).

Sample Data
-----------

- <b>first_10000_num_10000_lim.ods</b>: formatted OpenOffice Calc spreadsheet with 10 to 1000 base numbers and their Palindromic numbers (<i>if available</i>).
- <b>output_261iter.csv</b>: CSV file with 1186060307891929950 to 1186060307891929999 base numbers and their Palindromic numbers (<i>if available</i>).

Both these sample files are available in [/samples](https://github.com/dilshan/PalindromicGen/tree/master/samples) directory in PalindromicGen GitHub repository.

Project License
---------------

PalindromicGen is an open source software project and it is release under the terms of [MIT License](http://opensource.org/licenses/MIT).

