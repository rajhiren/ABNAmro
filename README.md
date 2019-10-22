[![Build Status](https://travis-ci.org/rajhiren/ABNAmro.svg?branch=master)](https://travis-ci.org/rajhiren/ABNAmro)  [![Coverage Status](https://coveralls.io/repos/github/rajhiren/ABNAmro/badge.svg?branch=master)](https://coveralls.io/github/rajhiren/ABNAmro?branch=master)

# ABN-Amro.
ABN Amro tech test submission

# you need to have following perl modules installed :

    Copy `ABNAmro` in `/usr/local/share/perl5/`

    use "cpanm to install following cpan modules"
    1.  Data::Dumper;
    2.  Text::CSV;
    3.  Term::ANSIColor;
    4.  Log::Log4perl;
    5.  Log::Log4perl::Level;
    6.  Cwd
    7.  Modern::Perl
    8.  Carp
    9.  Test::Exception

# Assumption :

  - it is closed system and input file is restricted
  - perl 5.16.0 is installed

# How To run :
  - Tests : ` prove tests/. `
  - Process  :  ` perl process.pl Input.txt `
  - for any issue it will show error message however please check my_errors.log for full information
  - log.conf is set to log everything

########### NOTE ###########

  If you don't have perl installed and find it difficult to install please let me know asap so I can provide Docker image as well.
  I simply did not include it because it will be overkill for such a small task.
