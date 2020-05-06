## Overview 

This project is a simple library to handle data in a 
consistent way when processing national membership lists
for local chapters to apply to the local chapter list.

This can be used either as a library inside of a script or app,
or as a script run on the command line.

### Use as a script

by running:

```
convert_membership_file filename.csv
```

A file of the name filename-new.csv will be created in the
same directory with the data translated as noted above.

### Use as a library

Get this gem by doing:

```
gem install dsa_national_membership
```

or include it in your Gemfile as follows

```
gem 'dsa_national_membership', git: "https://boberetezeke/dsa-national-membership.git"
```
