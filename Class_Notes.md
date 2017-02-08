# January 31, 2017

### Typora Demonstration

You can take themes from Typora by going to themes --> copy theme css and folder --> go to Rstudio--> options --> output options --> Paste CSS into browse bar

You can also take R ouputs by opening a saved file with Typora

### Nick's "Rant"

Don'ts:

* "umms" or "uhs" 
* too much mumbling and rushing
* introductory material?
  * too much (EEB)
  * too little (CMB)
* no uptalk! (controversial)
  * no intonation at the end of the sentence 
* Don't request feedback at the beginning of your talk

# February 2, 2017

### Nick's rant continued:

Do's:

* Make eye contact
* Project your voice - from your gut! (better than microphone) 
* Use the stage 
* Keep it short
  * when in doubt, always make your talk a little shorter than the time you have allotted 
* Use lots of slides
  * Don't leave a single image on the screen for awhile
  * Nick: 40 minute talk --> 100-120 slides
* Use sequential bullet points
* Don't read your slides
* Good graphics with large axes labels 
  * Always explain units, X and Y axes 
* Control lights
* No laser pointer 
  * Do use your body!

How to actually practice for your talk:

* Out-loud and standing-up
* Videotape yourself and see what you look and sound like!
* Give the talk to the mirror (if you can do this, you can do it in any situation!)
* Practice when you teach 

### Data Frame

* flat file (has rows and columns)
* Rows represent the **smallest possible sampling unit** 
* Columns represent attributes of samples (variables)
* All elements in a column are of one "type" (do not mix data types!)
* All columns of same length
  * Missing values should be consistently coded for as: **NA** 
  * Do not use blanks or zeros!
* Variable names should have no spaces or special characters 
  * Same goes for file names and folder names
* First variable should be **ID** 
  * Consecutive numbering  (unique)
  * Should not have any other details
* Nick has [posted](https://gotellilab.github.io/Bio381/Scripts/DataFormatting.html) code and more details for **smallest possible sampling unit**

### Dealing with metadata:

* {#} use hashtags to comment and embed metadata in data file
  * You will never lose it because it will always be attached to the data set
  * Nick [posted](https://gotellilab.github.io/Bio381/Scripts/RScripts.html) an excel spreadsheet with an example of metadata

### Publishing v Private in GitHub

* Private account ($)
* Use GitIgnore file to keep files secret

### **TO DO:**

* Try Nick's metadata formatting on one of your own data files

## R Coding

str(z)

$ is how R refers to any variable 



# February 7, 2017

## Regular expression

* Must be in a plain text editor 
* Can use regular expression in R studio (we will not be used in this class)
* Notepad ++ can be used
  * "." are **literal characters** 
  * **Metacharacters** (wildcards = metacharacter sequence)
    * **\w** - single "word" character (e.g. just a single character! all caps, all lower case, 0-9, and _ )
    * **\d** - single number character (e.g. 0-9)
    * **\t** - single tab space
    * **\s** - single tab, space, or line break
    * **\n** - single line break (may potentially be **\r** for Windows)
    * **.** - any single letter, digit, space, symbol, end of line
    * **()** - pair of parentheses will hang on to whatever is in the parentheses 
    * **\1** refers to the first set of parentheses 
  * **Negated wildcards** (capital letters!) Selects everything that is NOT 
    * **\W** - NOT \w
    * **\D** - NOT \d
    * **\T** - NOT \t
    * **\S** - NOT \s
  * **"Escaping the metacharacters"** allows you to search for specific literal characters
    * Forward slash and then character will escape the metacharacter
  * Custom character sets
    * **[]** - (e.g. [A-Z] will give you all uppercase letters, [A-Za-z] will give you all uppercase and lowercase letters) (this still only matches one character)
    * **[ACTG]** useful for finding all nucleotides
  * Negated character sets
    * **[^]** this will give you everything BUT what is in the brackets 
    * E.x. [^A-Za-z0-9_] is equivalent to \W
  * Quantifiers 
    * **\w+** - one or more consecutive word characters (must be a minimum of one)
      * The **+** symbol can be used for any of the wildcards we have used
    * **\w*** - 0 or more consecutive word characters (use when we are uncertain what will come up in the text)
      * e.x. crow, raven ,gracklestarling  ,    robin
      * Using *\s*,\s* and replacing with , will put it into properly formatted csv.
    * **\w{3}** - Exactly 3 consecutive word characters 
    * **\w{3,5}** - 3, 4, or 5 matches
    * **\w{3,}** - 3 or more matches
      * E.x. [ATCG]{3,} give at least 3 nucleotides 
    * **.*** - "Get everything" matches all text