# Tool.sh
University assignment to do some simple data file manipulation and practice regular expressions.

It's not perfect, i did it in 6 days. I will probably improve it soon.

Use on a data file of format:```id|lastName|firstName|gender|birthday|joinDate|IP|browserUsed|socialmedia```

```./tool.sh```—
Prints my university related social number

```./tool.sh -f <filename>```—
Prints the contents of the file excluding comments

```./tool.sh -f <filename> -id <id>```—
Prints the name, surname, birth date of the user with the given id 

```./tool.sh -f <filename> --firstnames```— 
Prints all discrete names in alphabetic order, one in each line

```./tool.sh -f <filename> --lastnames```— 
Prints all discrete surnames in alphabetic order, one in each line

```./tool.sh -f <filename> --born-since <dateA> --born-until <dateB>```— 
Prints all info about the users who are born since dateA born until dateB.
Can use either --born-since, --born-until or both of them

```./tool.sh -f <filename> --socialmedia```— 
Counts the how many appearances of each social media in the file

```./tool.sh -f <filename> --edit <id> <column> <value>```— 
Changes the value of column k of the user with the given id

###Note:
Parameters can be given in any order
```
./tool.sh --born-since <dateA> --born-until <dateB> -f <filename>
./tool.sh --born-until <dateB> -f <filename> --born-since <dateA>
./tool.sh –f <filename> --born-until <dateB> --born-since <dateA>
./tool.sh –f <filename> --born-since <dateA> --born-until <dateB>
```
