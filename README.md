# *BashSieve* <img src="https://raw.githubusercontent.com/urbanware-org/bashsieve/master/bashsieve.png" alt="BashSieve logo" height="128px" width="128px" align="right"/>

**Table of contents**
*   [Definition](#definition)
*   [Details](#details)
*   [Usage](#usage)
*   [Contact](#contact)

----

## Definition

Script to remove specific *Bash* history entries upon logout, to prevent critical commands and certain terms from remaining in it.

[Top](#bashsieve-)

## Details

If not disabled or manually cleared, the *Bash* keeps all the executed commands by writing them into its history file, including lines with passwords in it. For example, when executing

```bash
mount -t cifs //192.168.1.24/foobar /mnt \
      -o user=johndoe,pass=S3cr37P455wD
```

the username, password, and IP address will be kept inside the history unless you manually run the

```bash
history -c
```

command. Otherwise, the mount information remains in it. However, this command will clear the history by deleting all of its entries.

The *BashSieve* script simply removes specific user-defined *Bash* history entries on logout and prevents critical information (such as commands, passwords, IP addresses, etc.) from remaining in it.

So far, this tool is still very rudimentary.

[Top](#bashsieve-)

## Usage

First of all, add the following line at the end the `.bashrc` file inside of your home directory. For example, in case the *BashSieve* script is located in `/opt/bashsieve`:

```bash
trap '/opt/bashsieve/bashsieve.sh' exit
```

Of course, you can also place the script somewhere inside your home directory, but putting it into `/opt/bashsieve` makes it available for all users.

Edit the `bashsieve.list` file and add the corresponding commands or terms that should be removed by *BashSieve*. Details can be found inside that file.

After logging out and logging in again *BashSieve* will be triggered on every future logout and remove lines with the given terms in them.

Alternatively *BashSieve* can instantly be enabled by manually reloading your local `.bashrc` file using

```bash
. ~/.bashrc
```

or via the long form:

```bash
source ~/.bashrc
```

[Top](#bashsieve-)

## Contact

Any suggestions, questions, bugs to report or feedback to give?

You can contact me by sending an email to [dev@urbanware.org](mailto:dev@urbanware.org) or by opening a *GitHub* issue (which I would prefer if you have a *GitHub* account).

Further information can be found inside the `CONTACT` file.

[Top](#bashsieve-)
