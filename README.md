# Simple Testing Harness (sth)

   A set of scripts to facilitate automated testing of command-line programs. 

   The original or primary intent of the STH system is to facilate the automated testing of Java and MIPS subroutines.  And as such, the STH system utilizes a driver program.  For our purpose, the two primary driver programs are: [java_subroutine and mips_subroutine](https://github.com/smf-steve/mips_subroutine/blob/main/README.md)

   The STH system, however, has been developed to function without a driver program.  Hence, creating greater functionality.

## Demostrative Example

   Consider our exampl program[^1] that calculates the sum of a series of number from 1..10.  For example.

   ```bash
   $ sum 1 10
   55
   $
   ```

   As part of the software development process, we need to perform extensive testing to validate our programs work to the defined specification.  To automated this testing, we can create a set of test cases and then execute each of these test cases in turn. 

   We have defined two such test cases within the files `sum_1..10.sth_case` and `sum_0..10.sth_case`.  We can then use the `sth_validate` command to execute these two test case.  As a result, we can detect a problem with the "sum" program.

   * Test case 1:
      ```bash
      $ sth_validate sum_1..10.sth_case
      # Testing:   ./sum 1 10
      55

      Summary: 1/1  (Passed/Count)
      ```

   * Test case 2:
      ```bash
      $ sth_validate sum_0..10.sth_case
      # Testing:   ./sum 0 10
      54
      # ==========================
      # Error: Correct Output is:
      # ==========================
      55
      # ==========================

      Summary: 0/1  (Passed/Count)
      ```

   Obviously, we don't want to execute each of these test cases manually.  The 'sth_validate' command allows you to provide a list of files, and each file is processed in term.  If one of these files is a directory, all files with a .sth_case extention is added to the list of test cases to process. 

   Consider the following example where the first argument to sth_validate is the current working directory (.).  In this case, all the files within the current working directory (.) is executed.  A summary message is provided at the end of execution.

   * Test case 3:
      ```bash
      $ sth_validate .
      # Testing:   ./sum 0 10
      54
      # ==========================
      # Error: Correct Output is:
      # ==========================
      55
      # ==========================

      # Testing:   ./sum 1 10
      55
   
      Summary: 1/2  (Passed/Count)
      $ echo $?
      1
      $
      ```

   * Example .sth_case files

      ```bash
      $ cat sum_1..10.sth_case
      [case]
      ENTRY=./sum
      ARGS='1 10'   
      OUTPUT="55"
      $ cat sum_0..10.sth_case
      [case]
      ENTRY=./sum
      ARGS='0 10'
      OUTPUT="55"
      $
      ```
      
   [^1] All these tests cases are in the [example](https://github.com/smf-steve/sth/tree/main/example) subdirectory


## Commands:
   1. sth_validate {pathspec}... 
      - Executes and validates each test case that is provided in {pathspec}
        * if a {pathspec} is a directory, then every file with .sth_case.
      - During execution:
        * each test case is validated
        * transcript of activities are emitted to stderr
        * a summary of activities is emitted to stdout
      - The exit status ($?) is set to 0 for SUCCESS, when ALL test cases pass

   1. sth_execute {pathspec}...
      - Similar to `sth_validate`, but with the following differences
        * the validating step is skipped 
        * no transcript of activities are emtted to stdout
        * no summary information is presented
      - The exist status ($?) is set to the result of the last test case


## Test-case (.sth_case) File Format

By convention, test-cases are defined within a file with an .sth_case extentions.  Such a file may contain one or more test cases. The file is separated into one of three types of stanzas.  One of the following labels is used to start a stanza.

  1. The "[default]" label delinates the default values used for all test cases within the file.
  1. The "[case]" label delinates the start of a single test case
  1. The "[global]" label delinates the global values that override the defined values for a test case within the file.

The processing of the file begins within an implicit "[case]" stanza.  That is to say any file without a label to start a stanze defines a single test case.

Within each stanza, one or more of the following variables can be defined:

  | VARIABLE | Description                        | Example                  | Option    |
  |----------|------------------------------------|--------------------------|-----------|
  | DRIVER   | The default driver program         | java_subroutine          | Optional  |
  | OPTIONS  | The options passed to ${DRIVER}    | "-L '*.j'"               | Optional  |
  | ENTRY    | The entry point to start testing   | BinaryReal               | Required  |
  | ARGS     | The arguments passed to ${ENTRY}   | '8 \# 1234 "." 4300000'  | Optional  |
  | INPUT    | The provided input (stdin)         |                          | Optional  |
  | OUTPUT   | The expect output (stdout)         | "2# 1010011100.100011"   | Optional  |
  | EXITVAL  | The expected exit value            | 0                        | Optional  |


Given the example values above, the following command line is executed by 'sth_validate'.  In the example below, we also present the expected output and return value--for a success test.

  ```bash 
  $ cat | java_subroutine  -L '*.j'  BinaryReal 8 "\#" 1234 "." 43
  2# 1010011100.100011
  $ echo $?
  0
  ```

Notes:
   - the value of INPUT can either be a string or a filename
   - the value of OUTPUT can either be a string or a filename


## External Environment Variables

You can modify the behavior of the 'sth_validate' and 'sth_execute' by the use of environment variables.  The variables can be used to override particular VARIABLE for a test case.  The following environment variables are defined:

  | VARIABLE          | Overrides Variable with .sth_case files |
  |-------------------|-------------|
  | STH_DRIVER        | DRIVER      |
  | STH_OPTIONS       | OPTIONS     |
  | STH_ENTRY         | ENTRY       |
  | STH_ARGS          | ARGS        |
  | STH_INPUT         | INPUT       |
  | STH_OUTPUT        | OUTPUT      |
  | STH_EXITVAL       | EXITVAL     |

Additionly, you can define the STH_EXECUTE_ONLY to be "TRUE" to modify the behavior of std_validate to be quivelent to std_execute.


