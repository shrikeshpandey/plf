-- CONNECT SYS
ALTER SESSION SET EVENTS '10150 TRACE NAME CONTEXT FOREVER, LEVEL 1';
ALTER SESSION SET EVENTS '10904 TRACE NAME CONTEXT FOREVER, LEVEL 1';
ALTER SESSION SET EVENTS '25475 TRACE NAME CONTEXT FOREVER, LEVEL 1';
ALTER SESSION SET EVENTS '10407 TRACE NAME CONTEXT FOREVER, LEVEL 1';
ALTER SESSION SET EVENTS '10851 TRACE NAME CONTEXT FOREVER, LEVEL 1';
ALTER SESSION SET EVENTS '22830 TRACE NAME CONTEXT FOREVER, LEVEL 192 ';
-- new object type path: SCHEMA_EXPORT/USER
-- CONNECT SYSTEM
 CREATE USER "PLF_PROD" IDENTIFIED BY VALUES 'C258BF993B5101CB'
      DEFAULT TABLESPACE "PLF_PROD"
      TEMPORARY TABLESPACE "TEMP";
-- new object type path: SCHEMA_EXPORT/SYSTEM_GRANT
GRANT DEBUG CONNECT SESSION TO "PLF_PROD";
GRANT CREATE TYPE TO "PLF_PROD";
GRANT CREATE ANY DIRECTORY TO "PLF_PROD";
GRANT CREATE TRIGGER TO "PLF_PROD";
GRANT CREATE PROCEDURE TO "PLF_PROD";
GRANT CREATE SEQUENCE TO "PLF_PROD";
GRANT CREATE VIEW TO "PLF_PROD";
GRANT CREATE TABLE TO "PLF_PROD";
GRANT CREATE SESSION TO "PLF_PROD";
-- new object type path: SCHEMA_EXPORT/DEFAULT_ROLE
 ALTER USER "PLF_PROD" DEFAULT ROLE ALL;
-- new object type path: SCHEMA_EXPORT/TABLESPACE_QUOTA
DECLARE 
  TEMP_COUNT NUMBER; 
  SQLSTR VARCHAR2(200); 
BEGIN 
  SQLSTR := 'ALTER USER "PLF_PROD" QUOTA UNLIMITED ON "PLF_PROD"';
  EXECUTE IMMEDIATE SQLSTR;
EXCEPTION 
  WHEN OTHERS THEN
    IF SQLCODE = -30041 THEN 
      SQLSTR := 'SELECT COUNT(*) FROM USER_TABLESPACES 
              WHERE TABLESPACE_NAME = ''PLF_PROD'' AND CONTENTS = ''TEMPORARY''';
      EXECUTE IMMEDIATE SQLSTR INTO TEMP_COUNT;
      IF TEMP_COUNT = 1 THEN RETURN; 
      ELSE RAISE; 
      END IF;
    ELSE
      RAISE;
    END IF;
END;
/
-- new object type path: SCHEMA_EXPORT/PRE_SCHEMA/PROCACT_SCHEMA
-- CONNECT PLF_PROD

BEGIN 
sys.dbms_logrep_imp.instantiate_schema(schema_name=>SYS_CONTEXT('USERENV','CURRENT_SCHEMA'), export_db_name=>'SVDB', inst_scn=>'805187683960');
COMMIT; 
END; 
/ 
-- new object type path: SCHEMA_EXPORT/TYPE/TYPE_SPEC
-- CONNECT SYS

ALTER SESSION SET NLS_LENGTH_SEMANTICS=BYTE;

CREATE TYPE "PLF_PROD"."PLF_VARCHARTABLETYPE" 
  OID '365C68A1F64BCB9FE040A8C0A2C86A3F' as table of VARCHAR2(400);
 
/

ALTER TYPE "PLF_PROD"."PLF_VARCHARTABLETYPE" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

/

ALTER SESSION SET NLS_LENGTH_SEMANTICS=BYTE;

CREATE TYPE "PLF_PROD"."PLF_NUMBERTABLETYPE" 
  OID '365C68A1F633CB9FE040A8C0A2C86A3F' as table of number;
 
/

ALTER TYPE "PLF_PROD"."PLF_NUMBERTABLETYPE" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

/

ALTER SESSION SET NLS_LENGTH_SEMANTICS=BYTE;

CREATE TYPE "PLF_PROD"."PLF_STRING_AGG_TYPE" 
  OID '59B7DE68E098FBCAE040A8C0A5C80E45' AS OBJECT
(
  total VARCHAR2(32567),

  STATIC FUNCTION ODCIAggregateInitialize(sctx IN OUT plf_string_agg_type)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateIterate(SELF  IN OUT plf_string_agg_type,
                                       VALUE IN VARCHAR2) RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateTerminate(SELF        IN plf_string_agg_type,
                                         returnValue OUT CLOB,
                                         flags       IN NUMBER)
    RETURN NUMBER,

  MEMBER FUNCTION ODCIAggregateMerge(SELF IN OUT plf_string_agg_type,
                                     ctx2 IN plf_string_agg_type) RETURN NUMBER
)
;
/

ALTER TYPE "PLF_PROD"."PLF_STRING_AGG_TYPE" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

/
-- new object type path: SCHEMA_EXPORT/TYPE/GRANT/OWNER_GRANT/OBJECT_GRANT
-- CONNECT PLF_PROD
GRANT EXECUTE ON "PLF_PROD"."PLF_VARCHARTABLETYPE" TO "SV_PROD";
GRANT EXECUTE ON "PLF_PROD"."PLF_NUMBERTABLETYPE" TO "SV_PROD";
-- new object type path: SCHEMA_EXPORT/SEQUENCE/SEQUENCE
-- CONNECT SYS
 CREATE SEQUENCE  "PLF_PROD"."SEQ_ERRLOG"  MINVALUE 0 MAXVALUE 999999999 INCREMENT BY 1 START WITH 40924 CACHE 20 NOORDER  NOCYCLE ;
-- new object type path: SCHEMA_EXPORT/TABLE/TABLE
CREATE TABLE "PLF_PROD"."APPLICATIONS" 
   (	"APPLICATION_ID" NUMBER(11,0) CONSTRAINT "APPLICATION_ID_NN1" NOT NULL ENABLE, 
	"APPLICATION_NAME" VARCHAR2(40 CHAR) CONSTRAINT "APPLICATION_NAME_NN2" NOT NULL ENABLE, 
	"APP_CODE" VARCHAR2(5 CHAR) CONSTRAINT "APP_CODE_NN3" NOT NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 81920 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" ;
CREATE TABLE "PLF_PROD"."ERROR_MESSAGES" 
   (	"ERROR_CODE" NUMBER(5,0) CONSTRAINT "ERROR_CODE_NN1" NOT NULL ENABLE, 
	"APPLICATION_ID" NUMBER(11,0) CONSTRAINT "APPLICATION_ID_NN2" NOT NULL ENABLE, 
	"CONDITION_NAME" VARCHAR2(50 CHAR) CONSTRAINT "CONDITION_NAME_NN3" NOT NULL ENABLE, 
	"USER_MESSAGE" VARCHAR2(512 CHAR) CONSTRAINT "USER_MESSAGE_NN4" NOT NULL ENABLE, 
	"HELP_TEXT" VARCHAR2(4000 CHAR) CONSTRAINT "HELP_TEXT_NN5" NOT NULL ENABLE, 
	"CREATED_BY" VARCHAR2(40 CHAR) CONSTRAINT "CREATED_BY_NN6" NOT NULL ENABLE, 
	"CREATE_DATE" DATE CONSTRAINT "CREATE_DATE_NN7" NOT NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 81920 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" ;
CREATE TABLE "PLF_PROD"."ERRLOG" 
   (	"ERROR_ID" NUMBER(*,0) CONSTRAINT "ERROR_ID_NN1" NOT NULL ENABLE, 
	"APPLICATION_ID" NUMBER(11,0), 
	"ERROR_TIME" TIMESTAMP (6) CONSTRAINT "ERROR_TIME_NN3" NOT NULL ENABLE, 
	"ERROR_CODE" VARCHAR2(40 CHAR), 
	"ERROR_MESSAGE" VARCHAR2(4000 CHAR), 
	"STACK_TRACE" CLOB CONSTRAINT "STACK_TRACE_NN6" NOT NULL ENABLE, 
	"MODULE" VARCHAR2(400 CHAR), 
	"SESSION_ID" VARCHAR2(40 CHAR)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 81920 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" 
 LOB ("STACK_TRACE") STORE AS BASICFILE (
  TABLESPACE "PLF_PROD" ENABLE STORAGE IN ROW CHUNK 16384 PCTVERSION 10
  NOCACHE LOGGING 
  STORAGE(INITIAL 81920 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)) ;
-- new object type path: SCHEMA_EXPORT/TABLE/GRANT/OWNER_GRANT/OBJECT_GRANT
-- CONNECT PLF_PROD
GRANT SELECT ON "PLF_PROD"."ERRLOG" TO "SV_PROD";
-- new object type path: SCHEMA_EXPORT/TABLE/COMMENT
-- CONNECT SYS
 COMMENT ON COLUMN "PLF_PROD"."ERRLOG"."SESSION_ID" IS 'links to sv.dashboard_sessions.session_id';
-- new object type path: SCHEMA_EXPORT/PACKAGE/PACKAGE_SPEC
-- CONNECT PLF_PROD
CREATE PACKAGE            "PLF_DEF" AS


     TYPE t_recFileLineNo IS RECORD(
         line_no     INTEGER,
         datafile_id INTEGER);

     SUBTYPE st_status IS INTEGER(1);
     SUBTYPE st_errormsg IS VARCHAR2(2048); -- The size is defined as c_piERROR_STRING_SIZE in PLF_CONST package
     TYPE t_errormsgarray IS TABLE OF st_errormsg INDEX BY BINARY_INTEGER;

     SUBTYPE st_maxsizestring IS VARCHAR2(32767);
     SUBTYPE st_maxsizeraw IS RAW(32767);

     TYPE t_txtarray IS TABLE OF VARCHAR2(256) INDEX BY BINARY_INTEGER;
     TYPE t_intarray IS TABLE OF NUMBER(15, 0) INDEX BY BINARY_INTEGER;
     TYPE t_dblarray IS TABLE OF NUMBER(15, 6) INDEX BY BINARY_INTEGER;
     TYPE t_ridarray IS TABLE OF ROWID INDEX BY BINARY_INTEGER;
     TYPE t_FLarray IS TABLE OF t_recFileLineNo INDEX BY BINARY_INTEGER;

     empty_txt  t_txtarray;
     newrow_txt t_txtarray;
     empty_int  t_intarray;
     empty_dbl  t_dblarray;
     empty_rid  t_ridarray;
     newrow_rid t_ridarray;
     empty_fla  t_FLarray;

     TYPE t_cursorlist IS REF CURSOR;

 END PLF_DEF;
 

 
/
CREATE PACKAGE            "PLF_EH" IS


     c_strTABLE                CONSTANT VARCHAR2(5) := PLF_CONST.c_strTABLE;
     c_strFILE                 CONSTANT VARCHAR2(4) := PLF_CONST.c_strFILE;
     c_strCONSOLE              CONSTANT VARCHAR2(7) := PLF_CONST.c_strCONSOLE;
     c_strDEFAULT_LOG_TABLE    CONSTANT VARCHAR2(32) := PLF_CONST.c_strDEFAULT_LOG_TABLE;
     c_strDEFAULT_LOG_DIR      CONSTANT VARCHAR2(32) := PLF_CONST.c_strDEFAULT_LOG_DIR;
     c_strDEFAULT_LOG_FILE     CONSTANT VARCHAR2(32) := PLF_CONST.c_strDEFAULT_LOG_FILE;
     c_intGENERIC_ERROR_NUMBER CONSTANT INTEGER := PLF_CONST.c_intGENERIC_ERROR_NUMBER;
     c_int20000_ERROR_NUMBER   CONSTANT INTEGER := -20000; --PLF_CONST.c_int20000_ERROR_NUMBER;
     c_int20001_ERROR_NUMBER   CONSTANT INTEGER := -20001; --PLF_CONST.c_int20001_ERROR_NUMBER;
     c_default_system_message  CONSTANT VARCHAR2(400) := 'This is the generic system message';
     c_SharpView_AppCode       CONSTANT VARCHAR2(20) := 'SV';

     c_COLUMN_NOT_NULL_VIOLATION CONSTANT VARCHAR2(400) := 'COLUMN_NOT_NULL_VIOLATION';
    
     e_failed_procedure EXCEPTION;

     SUBTYPE st_ErrorMsg IS PLF_DEF.st_ErrorMsg;

     PROCEDURE create_Error_table;

     FUNCTION get_constraint(p_strErrorMessage IN VARCHAR2) RETURN VARCHAR2;

     PROCEDURE RaiseError;

     PROCEDURE RaiseUserDefinedException(p_strErrorMsg IN st_ErrorMsg);

     PROCEDURE RaiseSystemDefinedException(p_strException IN VARCHAR2);

     PROCEDURE LogError(p_strErrorCode       IN VARCHAR2 := NULL,
                        p_strErrorMessage    IN VARCHAR2 := NULL,
                        p_strStackTrace      IN VARCHAR2 := NULL,
                        p_intApplicationId   IN VARCHAR2 := NULL,
                        p_strModule          IN VARCHAR2 := NULL,
                        p_strSessionID       IN VARCHAR2 := NULL,
                        p_strTarget          IN VARCHAR2 := NULL,
                        p_strTargetTableName IN VARCHAR2 := NULL,
                        p_strTargetDir       IN VARCHAR2 := NULL,
                        p_strTargetFile      IN VARCHAR2 := NULL,
                        p_intErrorID         OUT INTEGER);

     PROCEDURE LogError(p_strErrorCode       IN PLS_INTEGER := NULL,
                        p_strErrorMessage    IN VARCHAR2 := NULL,
                        p_strStackTrace      IN VARCHAR2 := NULL,
                        p_strModule          IN VARCHAR2 := NULL,
                        p_strSessionID       IN VARCHAR2 := NULL,
                        p_strTarget          IN VARCHAR2 := NULL,
                        p_strTargetTableName IN VARCHAR2 := NULL,
                        p_strTargetDir       IN VARCHAR2 := NULL,
                        p_strTargetFile      IN VARCHAR2 := NULL);


 END PLF_EH;
 

 
/
CREATE PACKAGE PLF_UTIL
AUTHID CURRENT_USER
AS

    -----------------------------------------------------------------------------
    -- This package contains a list of useful PL/SQL utility procedures and functions
    --
    -----------------------------------------------------------------------------

    -- H. Wang       2002        Created for Coelacanth
    -- J. Stowell    Dec 2002    Added Sendmail procedure
    -- J. Stowell    Mar 2003    Added a get global database name procedure
    -- J. Stowell    Sep 2003    Reworked to make generic
    -- J. Stowell    May 2004    Added file write procs
    -- J. Stowell    Jul 2004    Added External Table creation proc
    -- J. Stowell    Sep 2004    Updated ExternalTable to drop table first.
    -- J. Stowell    Nov 2005    Modified Externaltable to allow very large SQL


	TYPE rec_filefield IS RECORD(
		filefield_id    INTEGER,
		filetype_id     INTEGER,
		fieldtype_id    INTEGER,
		mf_id           INTEGER,
		field_name      VARCHAR2(64),
		field_datatype  VARCHAR2(64),
		field_length    INTEGER,
		field_precision INTEGER,
		field_order     INTEGER,
		field_begin     INTEGER,
		field_end       INTEGER,
		field_desc      VARCHAR2(4000),
		field_method    VARCHAR2(4000),
		nullable        CHAR(1),
    standardization_group  varchar2(128));

	TYPE t_Fields IS TABLE OF rec_filefield INDEX BY BINARY_INTEGER;
	TYPE f_Fields IS TABLE OF rec_filefield INDEX BY BINARY_INTEGER;

    -------------------------------------------------------------------------
    -- General routines
    -------------------------------------------------------------------------
    PROCEDURE pl(p_strOutput IN VARCHAR2, p_piLen IN PLS_INTEGER := 80);
    -- Description:     Wrapper function for DBMS_OUTPUT.PUT_LINE procedure
    -- Parameters:
    --  p_strOutput:    String to output to console
    --  p_piLen:        Column at which the text will wrap

    -------------------------------------------------------------------------
    -- Validation routines
    -------------------------------------------------------------------------
    FUNCTION bIsNumber(p_strIn IN VARCHAR2) RETURN BOOLEAN;
    -- Description:     Verify a string to be a number
    -- Parameters:
    --  p_strIn:        String to verify

    PRAGMA RESTRICT_REFERENCES(bIsNumber, WNDS);

    -------------------------------------------------------------------------
    -- String manipulation routines
    -------------------------------------------------------------------------
    FUNCTION strInitString(p_piStringSize IN PLS_INTEGER := 2048,
                           p_strInit      IN VARCHAR2 := ' ') RETURN VARCHAR2;

    -- Description:         Initialize a string to a given size of no more than 4096.
    -- Returned:            Initialized string
    --
    -- Parameters:
    --  p_piStringSize:     Number of characters for the returned string
    --  p_chrInit:          Initialization character (only the first character is used).
    --                      ' ' is used if p_strInit is empty
    --

    -------------------------------------------------------------------------
    FUNCTION strConcatString(p_str1     IN VARCHAR2,
                             p_str2     IN VARCHAR2,
                             p_strDelim IN VARCHAR2 := PLF_CONST.c_strCRLF)
        RETURN VARCHAR2;
    -- Description:         Cancatenate strings into one combined string separated by delimitor.
    -- Returned:            Combined string
    --
    -- Parameters:
    --  p_str1:             First string
    --  p_str2:             Second string
    --  p_strDelim:         String delimitor
    --

    -------------------------------------------------------------------------
    PROCEDURE SendMail(p_strSender    IN VARCHAR2,
                       p_strRecipient IN VARCHAR2,
                       p_strSubject   IN VARCHAR2,
                       p_strBody      IN VARCHAR2);
    -- Description:     Procedure to send email from within PL/SQL. Uses DBMS_SMTP.
    -- Parameters:
    --  p_strSender:      Sender of emial.  use senders email address, app anme or DB name.
    --  p_strRecipient:
    --  p_strSubject:
    --  p_strBody:

    -------------------------------------------------------------------------
    FUNCTION GetDBName RETURN VARCHAR2;
    -- Description:     Procedure to get the global database name.
    -- Return:          Global database name.

    -------------------------------------------------------------------------------
    FUNCTION CSVToTable(p_strCSV IN VARCHAR2) RETURN DBMS_SQL.Varchar2_Table;
    -- Description:     Function to convert a comma seperated list of values to an array.
    -- Parameters :
    --  p_strCSV  :     a list of values
    -- Return     :     pl/sql table of values

    -------------------------------------------------------------------------------
    FUNCTION WriteDelimited(p_strQuery     IN VARCHAR2,
                            p_strSeperator IN VARCHAR2,
                            p_strDirectory IN VARCHAR2,
                            p_strFileName  IN VARCHAR2) RETURN NUMBER;
    -- Description:     write the results of query to a file in delimited format
    -- Parameters:
    --  p_strQuery:     query that determines the contents of the file
    --  p_strSeperator: the delimited between field values
    --  p_strDirectory: where the file is written. Must be DB directory object.
    --  p_strFileName:  name of the file
    -- Return:          number of lines written to file

    -------------------------------------------------------------------------------
    FUNCTION WriteFixed(p_strQuery         IN VARCHAR2,
                        p_strColumnLengths IN VARCHAR2,
                        p_strDirectory     IN VARCHAR2,
                        p_strFileName      IN VARCHAR2) RETURN NUMBER;
    -- Description:     rite the results of query to a file in fixed format
    -- Parameters:
    --  p_strQuery:         Sender of emial.  use senders email address, app anme or DB name.
    --  p_strColumnLengths: a commas seperated list of integers deknoting the fields lengths
    --  p_strDirectory:     where the file is written. Must be DB directory object.
    --  p_strFileName:      name of the file
    -- Return:              number of lines written to file

    -------------------------------------------------------------------------------------------
    PROCEDURE ExternalTable(p_strTableName           IN VARCHAR2,
                            p_strLocation           IN VARCHAR2,
                            p_strDefaultDirectory   IN VARCHAR2,
                            p_tabFields             IN t_Fields,
                            p_strRecordsDelimtedBy  IN VARCHAR2,
                            p_strCharacterSet       IN VARCHAR2,
                            p_intSkip               IN INTEGER,
                            p_strFieldsTerminatedBy IN VARCHAR2,
                            p_strOptionallyEnclosedBy IN VARCHAR2,
                            p_strMissingFieldValues IN VARCHAR2,
                            p_strTrim               IN VARCHAR2);
    -- Description:     Create an external table from meta data in FILEFIELD table
    -- Parameters:
    --            p_srtablename            owner and name of tbl to be made (owner.table_name)
                  /*
                  TODO: owner="jstowell" category="Optimize" priority="2 - Medium" created="6/3/2008"
                  text="sperate out owner as an additional paramter."
                  */    
    --            p_strlocation            file name
    --            p_strdefaultdirectory    directory of file
    --            p_tabfields              fields in file
    --            p_strrecordsdelimtedby   record delimeter
    --            p_intskip                records to skip
    --            p_strfieldsterminatedby  filed delimiter
    --            p_strmissingfieldvalues  what to do with missing values
    --            p_strtrim


    --------------------------------------------------------------------
    FUNCTION isdate(p_str IN VARCHAR2, p_format VARCHAR2) RETURN DATE;
    
    --------------------------------------------------------------------
    FUNCTION escapeForOracle(p_str IN VARCHAR2) RETURN VARCHAR2;
    -- Description:    Replace characters that mess up Oracle insert statements
    
    --------------------------------------------------------------------
    FUNCTION escapeForOracleObjectName(p_str IN VARCHAR2) RETURN VARCHAR2;
    -- Description:    Replace characters and fix length to match valid Oracle
    --                 object names
    
    --------------------------------------------------------------------
    FUNCTION isNumber(p_str IN VARCHAR2) RETURN BOOLEAN;
    -- Description:    Determine if a string is a number
    
    --------------------------------------------------------------------
    FUNCTION Parse256(p_strIn IN VARCHAR2) RETURN dbms_sql.varchar2s;
    -- Description:  Parse a string into a collection.
    --               Break at each space and preserve the space
    --               as the last char of the snipper.

    --------------------------------------------------------------------
    PROCEDURE Fast_ET(p_strTableName            IN VARCHAR2,
                      p_strLocation             IN VARCHAR2,
                      p_strDefaultDirectory     IN VARCHAR2,
                      p_strFields               IN VARCHAR2,
                      p_strRecordsDelimtedBy    IN VARCHAR2,
                      p_strCharacterSet         IN VARCHAR2,
                      p_intSkip                 IN INTEGER,
                      p_strFieldsTerminatedBy   IN VARCHAR2,
                      p_strOptionallyEnclosedBy IN VARCHAR2,
                      p_strMissingFieldValues   IN VARCHAR2,
                      p_strTrim                 IN VARCHAR2,
                      p_bHeader                 IN BOOLEAN);
  -- Create an ET quickly without going through the normal FELIX process
  -- JStowell Sep 2005
  
  -----------------------------------------------------------------------
  FUNCTION isNumeric(p_str VARCHAR2) RETURN VARCHAR2;
  

END PLF_UTIL;
/
CREATE PACKAGE            "PLF_CONST" AS

    -----------------------------------------------------------------------------
    -- This package defines constants with global scope for all PL/SQL objects
    --
    -- It does not have a package body.
    --
    --  2/14/2004  Updated for LASH data
    --  7/2004     Ported to ICON project
    -----------------------------------------------------------------------------
    /*
    
       this is line 1 of multi line comment
       this is line 2 of multi line comment
    
    */
    -----------------------------------------------------------------------------
    -- General constants
    c_strcr   CONSTANT VARCHAR2(1) := chr(13); -- Carriage Return
    c_strlf   CONSTANT VARCHAR2(1) := chr(10); -- Line Feed
    c_strcrlf CONSTANT VARCHAR2(2) := c_strcr || c_strlf; -- Both
    c_strSpace CONSTANT CHAR(1) := ' ';

    c_pimaxstr_size CONSTANT PLS_INTEGER := 32767;
    c_pimaxraw_size CONSTANT PLS_INTEGER := c_pimaxstr_size;

    c_pierror_string_size CONSTANT PLS_INTEGER := 2048;

    -----------------------------------------------------------------------------
    -- Unlikely primary key ID
    c_unacceptable_pk_id CONSTANT PLS_INTEGER := -1;

    -----------------------------------------------------------------------------
    -- Exception Handling constants
    c_intgeneric_error_number CONSTANT INTEGER := -20000;

    c_intuser_min_exception_num CONSTANT INTEGER := -20999;
    c_intuser_max_exception_num CONSTANT INTEGER := -20001;
    
    c_strTABLE CONSTANT VARCHAR2(5) := 'TABLE';
    c_strFILE CONSTANT VARCHAR2(4) := 'FILE';
    c_strCONSOLE CONSTANT VARCHAR2(7) := 'CONSOLE';
    c_strDEFAULT_LOG_TABLE CONSTANT VARCHAR2(32) := 'ERRLOG';
    c_strDEFAULT_LOG_DIR CONSTANT VARCHAR2(32) := 'ERROR_LOG';
    c_strDEFAULT_LOG_FILE CONSTANT VARCHAR2(32) := 'error_log.txt';

    -----------------------------------------------------------------------------
    -- The time period which a web session remains alive from user's
    -- last 'visit' to the database.
    c_pisession_time_in_min CONSTANT PLS_INTEGER := 34560; -- In minutes

    -- Convert the minutes into days
    c_piminute_in_day        CONSTANT PLS_INTEGER := 60 * 24;
    c_numsession_time_in_day CONSTANT NUMBER(15, 8) := (c_pisession_time_in_min /c_piminute_in_day);

    -----------------------------------------------------------------------------
    -- Misc
    c_pichunk CONSTANT PLS_INTEGER := 1024;

    -----------------------------------------------------------------------------
    -- Trans codes
    c_strXXX CONSTANT VARCHAR2(5) := 'XXX';

    -- Generic Status values
    c_strSUCCESS CONSTANT VARCHAR2(40) := 'SUCCESS';
    c_strFAILURE CONSTANT VARCHAR2(40) := 'FAILURE';
    c_strDollarSign CONSTANT VARCHAR2(40) := '$';

    -- DATAFILE status values
--    c_strNEW         CONSTANT VARCHAR2(15) := 'NEW';
    c_strRETRIEVED   CONSTANT VARCHAR2(15) := 'RETRIEVED';
    c_strETED        CONSTANT VARCHAR2(15) := 'ETED';
    c_strQCED        CONSTANT VARCHAR2(15) := 'QCED';
    c_strLOADED      CONSTANT VARCHAR2(15) := 'LOADED';
    c_strTRANSFORMED CONSTANT VARCHAR2(15) := 'TRANSFORMED';
    c_strFULFILLED   CONSTANT VARCHAR2(15) := 'FULFILLED';

    -- Replacment Tokens
    c_strDateToken CONSTANT VARCHAR2(64) := '{YYYYMMDD}';

    -- System state constants
    c_strNew         CONSTANT VARCHAR2(64) := 'NEW';
    c_strRETRIEVE    CONSTANT VARCHAR2(64) := 'RETRIEVE';
    c_strET          CONSTANT VARCHAR2(64) := 'ET';
    c_strETQC        CONSTANT VARCHAR2(64) := 'ETQC';
    c_strETPASSQC    CONSTANT VARCHAR2(64) := 'ETPASSQC';
    c_strIT          CONSTANT VARCHAR2(64) := 'IT';
    c_strSTANDARDIZE CONSTANT VARCHAR2(64) := 'STANDARDIZE';
    c_strITQC        CONSTANT VARCHAR2(64) := 'ITQC';
    c_strITPASSQC    CONSTANT VARCHAR2(64) := 'ITPASSQC';
    c_strSTAGE       CONSTANT VARCHAR2(64) := 'STAGE';
    c_strSTAGEQC     CONSTANT VARCHAR2(64) := 'STAGEQC';
    c_strSTAGEPASSQC CONSTANT VARCHAR2(64) := 'STAGEPASSQC';
    c_strSTAR        CONSTANT VARCHAR2(64) := 'STAR';
    c_strSTARQC      CONSTANT VARCHAR2(64) := 'STARQC';
    c_strSTARPASSQC  CONSTANT VARCHAR2(64) := 'STARPASSQC';

    c_strDIMPERSON   CONSTANT VARCHAR2(64) := 'DIMPERSON';

    -- System Action constants
    c_strDELETESTAGERECORDS CONSTANT VARCHAR2(64) := 'DELETESTAGERECORDS';

    c_strETPrefix CONSTANT VARCHAR2(10) := 'ET_';
    c_strITPrefix CONSTANT VARCHAR2(10) := 'IT_';

END PLF_CONST;

 
/
CREATE PACKAGE            "PLF_GRANTSCHEMAACCESS" IS


     TYPE t_object_List IS TABLE OF VARCHAR2(20) INDEX BY BINARY_INTEGER;

     c_select    CONSTANT VARCHAR2(20) := 'SELECT';
     c_insert    CONSTANT VARCHAR2(20) := 'INSERT';
     c_update    CONSTANT VARCHAR2(20) := 'UPDATE';
     c_delete    CONSTANT VARCHAR2(20) := 'DELETE';
     c_execute   CONSTANT VARCHAR2(20) := 'EXECUTE';
     c_reference CONSTANT VARCHAR2(20) := 'REFERENCES';

     c_table             CONSTANT VARCHAR2(20) := 'TABLE';
     c_view              CONSTANT VARCHAR2(20) := 'VIEW';
     c_materialized_view CONSTANT VARCHAR2(20) := 'MATERIALIZED VIEW';
     c_package           CONSTANT VARCHAR2(20) := 'PACKAGE';
     c_package_body      CONSTANT VARCHAR2(20) := 'PACKAGE BODY';
     c_procedure         CONSTANT VARCHAR2(20) := 'PROCEDURE';
     c_function          CONSTANT VARCHAR2(20) := 'FUNCTION';
     c_sequence          CONSTANT VARCHAR2(20) := 'SEQUENCE';

     FUNCTION isValidGrant(p_ObjectType IN VARCHAR2, p_Access IN VARCHAR2) RETURN BOOLEAN;

     PROCEDURE GrantAccess(p_Grantor    IN VARCHAR2,
                           p_Grantee    IN VARCHAR2,
                           p_ObjectType IN VARCHAR2,
                           p_Access     IN VARCHAR2);
                          
     PROCEDURE RevokeAccess(p_Grantor    IN VARCHAR2,
                           p_Grantee    IN VARCHAR2,
                           p_ObjectType IN VARCHAR2,
                           p_Access     IN VARCHAR2);
                          
 END PLF_GrantSchemaAccess;
 

 
/
CREATE PACKAGE          "EM_MAINT" IS

	PROCEDURE create_message
	(
		p_strAppCode       IN VARCHAR2,
		p_strConditionName IN VARCHAR2,
		p_strUserMessage   IN VARCHAR2,
		p_strHelpText      IN VARCHAR2 DEFAULT NULL,
		p_strCreatedBy     IN VARCHAR2
	);

	PROCEDURE update_message
	(
		p_intErrorCode     IN ERROR_MESSAGES.ERROR_CODE%TYPE,
		p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
		p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
		p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
		p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE
	);

	PROCEDURE sync;

	PROCEDURE list(p_strAppCode IN APPLICATIONS.APP_CODE%TYPE DEFAULT NULL);

END em_maint;
/
CREATE PACKAGE            "PLF_METADATA" 
  IS
  
  PROCEDURE load;
 
  PROCEDURE sync;
 
  PROCEDURE reset; 

  

  END plf_metadata;
 
 

 
/
CREATE PACKAGE            "PLF_APPLICATIONS_DML" 
 IS


     TYPE t_applications IS TABLE OF applications%ROWTYPE INDEX BY BINARY_INTEGER;
     SUBTYPE rec_applicatoin IS applications%ROWTYPE;







    FUNCTION get_applications
    RETURN t_applications;

     FUNCTION get_application(p_strAppCode IN applications.app_code%TYPE)
        RETURN applications%ROWTYPE;

   PROCEDURE create_application(p_strApplicationName IN APPLICATIONS.APPLICATION_NAME%TYPE,
                                p_strAppCode         IN APPLICATIONS.APP_CODE%TYPE,
                                p_intApplicationId   OUT APPLICATIONS.APPLICATION_ID%TYPE);

   PROCEDURE update_application(p_intApplicationId   IN APPLICATIONS.APPLICATION_ID%TYPE,
                                p_strApplicationName IN APPLICATIONS.APPLICATION_NAME%TYPE,
                                p_strAppCode         IN APPLICATIONS.APP_CODE%TYPE);

    PROCEDURE delete_application(p_intApplicationId IN APPLICATIONS.APPLICATION_ID%TYPE);

 END PLF_APPLICATIONS_DML;
 

 
/
CREATE PACKAGE            "PLF_ERROR_MESSAGES_DML" 
 IS





   PROCEDURE create_error_message(p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
                                   p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
                                   p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
                                   p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE,
                                   p_strCreatedBy     IN ERROR_MESSAGES.CREATED_BY%TYPE,
                                   p_intErrorCode     OUT ERROR_MESSAGES.ERROR_CODE%TYPE);
                                  
   PROCEDURE update_error_message(p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
                                   p_intErrorCode     IN ERROR_MESSAGES.ERROR_CODE%TYPE,
                                   p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
                                   p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
                                   p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE);

 END plf_error_messages_dml;
 

 
/
-- new object type path: SCHEMA_EXPORT/PACKAGE/GRANT/OWNER_GRANT/OBJECT_GRANT
GRANT EXECUTE ON "PLF_PROD"."PLF_DEF" TO "SV_PROD";
GRANT EXECUTE ON "PLF_PROD"."PLF_EH" TO "SV_PROD";
GRANT EXECUTE ON "PLF_PROD"."PLF_UTIL" TO "SV_PROD";
GRANT EXECUTE ON "PLF_PROD"."PLF_CONST" TO "SV_PROD";
GRANT EXECUTE ON "PLF_PROD"."PLF_GRANTSCHEMAACCESS" TO "SV_PROD";
-- new object type path: SCHEMA_EXPORT/FUNCTION/FUNCTION
CREATE FUNCTION          plf_stragg(input varchar2) RETURN CLOB
  PARALLEL_ENABLE
  AGGREGATE USING plf_string_agg_type;
/
-- new object type path: SCHEMA_EXPORT/FUNCTION/GRANT/OWNER_GRANT/OBJECT_GRANT
GRANT EXECUTE ON "PLF_PROD"."PLF_STRAGG" TO "SV_PROD";
-- new object type path: SCHEMA_EXPORT/PACKAGE/COMPILE_PACKAGE/PACKAGE_SPEC/ALTER_PACKAGE_SPEC

ALTER PACKAGE "PLF_PROD"."PLF_DEF" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:51:26'
/

ALTER PACKAGE "PLF_PROD"."PLF_EH" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:51:26'
/

ALTER PACKAGE "PLF_PROD"."PLF_UTIL" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:51'
/

ALTER PACKAGE "PLF_PROD"."PLF_CONST" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:51:26'
/

ALTER PACKAGE "PLF_PROD"."PLF_GRANTSCHEMAACCESS" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:51'
/

ALTER PACKAGE "PLF_PROD"."EM_MAINT" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:52'
/

ALTER PACKAGE "PLF_PROD"."PLF_METADATA" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:52'
/

ALTER PACKAGE "PLF_PROD"."PLF_APPLICATIONS_DML" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:53'
/

ALTER PACKAGE "PLF_PROD"."PLF_ERROR_MESSAGES_DML" 
  COMPILE SPECIFICATION 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:53'
/
-- new object type path: SCHEMA_EXPORT/FUNCTION/ALTER_FUNCTION

ALTER FUNCTION "PLF_PROD"."PLF_STRAGG" 
  COMPILE 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:58:51'
/
-- new object type path: SCHEMA_EXPORT/TABLE/INDEX/INDEX
CREATE UNIQUE INDEX "PLF_PROD"."ERROR_MESSAGES_PK" ON "PLF_PROD"."ERROR_MESSAGES" ("ERROR_CODE", "APPLICATION_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."ERROR_MESSAGES_PK" NOPARALLEL;
CREATE UNIQUE INDEX "PLF_PROD"."ERROR_MESSAGES_UK1" ON "PLF_PROD"."ERROR_MESSAGES" ("CONDITION_NAME", "APPLICATION_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."ERROR_MESSAGES_UK1" NOPARALLEL;
CREATE UNIQUE INDEX "PLF_PROD"."APPLICATIONS_UK1" ON "PLF_PROD"."APPLICATIONS" ("APPLICATION_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."APPLICATIONS_UK1" NOPARALLEL;
CREATE UNIQUE INDEX "PLF_PROD"."APPLICATIONS_UK2" ON "PLF_PROD"."APPLICATIONS" ("APP_CODE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."APPLICATIONS_UK2" NOPARALLEL;
CREATE UNIQUE INDEX "PLF_PROD"."APPLICATIONS_PK" ON "PLF_PROD"."APPLICATIONS" ("APPLICATION_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."APPLICATIONS_PK" NOPARALLEL;
CREATE UNIQUE INDEX "PLF_PROD"."ERRLOG_PK" ON "PLF_PROD"."ERRLOG" ("ERROR_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD" PARALLEL 1 ;

  ALTER INDEX "PLF_PROD"."ERRLOG_PK" NOPARALLEL;
-- new object type path: SCHEMA_EXPORT/TABLE/CONSTRAINT/CONSTRAINT
-- CONNECT SYS
ALTER TABLE "PLF_PROD"."ERROR_MESSAGES" ADD CONSTRAINT "ERROR_MESSAGES_UK1" UNIQUE ("CONDITION_NAME", "APPLICATION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
ALTER TABLE "PLF_PROD"."ERROR_MESSAGES" ADD CONSTRAINT "ERROR_MESSAGES_PK" PRIMARY KEY ("ERROR_CODE", "APPLICATION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
ALTER TABLE "PLF_PROD"."APPLICATIONS" ADD CONSTRAINT "APPLICATIONS_UK2" UNIQUE ("APP_CODE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
ALTER TABLE "PLF_PROD"."APPLICATIONS" ADD CONSTRAINT "APPLICATIONS_UK1" UNIQUE ("APPLICATION_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
ALTER TABLE "PLF_PROD"."APPLICATIONS" ADD CONSTRAINT "APPLICATIONS_PK" PRIMARY KEY ("APPLICATION_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
ALTER TABLE "PLF_PROD"."ERRLOG" ADD CONSTRAINT "ERRLOG_PK" PRIMARY KEY ("ERROR_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "PLF_PROD"  ENABLE;
-- new object type path: SCHEMA_EXPORT/TABLE/INDEX/STATISTICS/INDEX_STATISTICS
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'ERRLOG_PK'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,30603,31,30603,1,1,17529,1,30603,NV,NV,TO_DATE('2009-12-03 12:55:23',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'ERROR_MESSAGES_PK'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,32,1,32,1,1,1,0,32,NV,NV,TO_DATE('2009-12-03 12:55:26',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'ERROR_MESSAGES_UK1'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,32,1,32,1,1,1,0,32,NV,NV,TO_DATE('2009-12-03 12:55:26',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'APPLICATIONS_UK1'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,1,1,1,1,1,1,0,1,NV,NV,TO_DATE('2009-12-03 12:55:26',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'APPLICATIONS_UK2'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,1,1,1,1,1,1,0,1,NV,NV,TO_DATE('2009-12-03 12:55:26',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
DECLARE I_N VARCHAR2(60); 
  I_O VARCHAR2(60); 
  NV VARCHAR2(1); 
  c DBMS_METADATA.T_VAR_COLL; 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
 stmt varchar2(300) := ' INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,n12,d1,cl1) VALUES (''I'',6,:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,NULL,:14,:15,NULL,:16,:17)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  i_n := 'APPLICATIONS_PK'; 
  i_o := 'PLF_PROD'; 
  EXECUTE IMMEDIATE stmt USING 2,I_N,NV,NV,I_O,1,1,1,1,1,1,0,1,NV,NV,TO_DATE('2009-12-03 12:55:26',df),NV;

  DBMS_STATS.IMPORT_INDEX_STATS('"' || i_o || '"','"' || i_n || '"',NULL,'"IMPDP_STATS"',NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/
-- new object type path: SCHEMA_EXPORT/PACKAGE/PACKAGE_BODY
-- CONNECT PLF_PROD
CREATE PACKAGE BODY          "EM_MAINT" IS

	PROCEDURE p(p_strMessage IN VARCHAR2) IS
	BEGIN
		DBMS_OUTPUT.PUT_LINE(p_strMessage);
	END p;

	PROCEDURE create_message
	(
		p_strAppCode       IN VARCHAR2,
		p_strConditionName IN VARCHAR2,
		p_strUserMessage   IN VARCHAR2,
		p_strHelpText      IN VARCHAR2 DEFAULT NULL,
		p_strCreatedBy     IN VARCHAR2
	) IS
		v_intErrorCode PLS_INTEGER;
	BEGIN
		plf_error_messages_dml.create_error_message@spdev_xe(p_strAppCode       => p_strAppCode,
																			  p_strConditionName => p_strConditionName,
																			  p_strUserMessage   => p_strUserMessage,
																			  p_strHelpText      => p_strHelpText,
																			  p_strCreatedBy     => p_strCreatedBy,
																			  p_intErrorCode     => v_intErrorCode);
		plf_error_messages_dml.create_error_message(p_strAppCode       => p_strAppCode,
																  p_strConditionName => p_strConditionName,
																  p_strUserMessage   => p_strUserMessage,
																  p_strHelpText      => p_strHelpText,
																  p_strCreatedBy     => p_strCreatedBy,
																  p_intErrorCode     => v_intErrorCode);
	
		COMMIT;
	
		p('New error message created successfully.  Error Code: ' || v_intErrorcode);
	
	END create_message;

	PROCEDURE update_message
	(
		p_intErrorCode     IN ERROR_MESSAGES.ERROR_CODE%TYPE,
		p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
		p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
		p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
		p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE
	) IS
	BEGIN
		plf_error_messages_dml.update_error_message@spdev_xe(p_strAppCode       => p_strAppCode,
																			  p_intErrorCode     => p_intErrorCode,
																			  p_strConditionName => p_strConditionName,
																			  p_strUserMessage   => p_strUserMessage,
																			  p_strHelpText      => p_strHelpText);
	
		plf_error_messages_dml.update_error_message(p_strAppCode       => p_strAppCode,
																  p_intErrorCode     => p_intErrorCode,
																  p_strConditionName => p_strConditionName,
																  p_strUserMessage   => p_strUserMessage,
																  p_strHelpText      => p_strHelpText);
	
		COMMIT;
	
	END update_message;

	PROCEDURE sync IS
	BEGIN
		MERGE INTO error_messages t
		USING plf.error_messages@spdev_xe s
		ON (t.ERROR_CODE = s.ERROR_CODE AND t.application_id = s.application_id)
		WHEN MATCHED THEN
			UPDATE
				SET t.condition_name = s.condition_name,
					 t.user_message   = s.user_message,
					 t.help_text      = s.help_text,
					 t.created_by     = s.created_by,
					 t.create_date    = s.create_date
		WHEN NOT MATCHED THEN
			INSERT
				(t.ERROR_CODE,
				 t.application_id,
				 t.condition_name,
				 t.user_message,
				 t.help_text,
				 t.created_by,
				 t.create_date)
			VALUES
				(s.ERROR_CODE,
				 s.application_id,
				 s.condition_name,
				 s.user_message,
				 s.help_text,
				 s.created_by,
				 s.create_date);
	
		COMMIT;
	
	END sync;

	PROCEDURE list(p_strAppCode IN APPLICATIONS.APP_CODE%TYPE DEFAULT NULL) IS
		CURSOR cur_em_app(cp_app_code IN VARCHAR2) IS
			SELECT a.app_code,
					 e.ERROR_CODE,
					 e.condition_name,
					 e.user_message,
					 e.help_text
			  FROM error_messages e NATURAL
			  JOIN applications a
			 WHERE UPPER(a.app_code) = UPPER(cp_app_code)
			 ORDER BY 1,
						 2;
	
		CURSOR cur_em_all IS
			SELECT a.app_code,
					 e.ERROR_CODE,
					 e.condition_name,
					 e.user_message,
					 e.help_text
			  FROM error_messages e NATURAL
			  JOIN applications a
			 ORDER BY 1,
						 2;
	
	BEGIN
		IF (p_strAppCode IS NOT NULL)
		THEN
			FOR rec IN cur_em_app(p_strAppCode)
			LOOP
				p(rec.app_code || ' ' || rec.ERROR_CODE || ' ' || rec.condition_name || ' ' ||
				  rec.user_message || ' ' || rec.help_text);
			END LOOP;
		ELSE
			FOR rec IN cur_em_all
			LOOP
				p(rec.app_code || ' ' || rec.ERROR_CODE || ' ' || rec.condition_name || ' ' ||
				  rec.user_message || ' ' || rec.help_text);
			END LOOP;
		
		END IF;
	END list;

BEGIN
	NULL;
END em_maint;
/
CREATE PACKAGE BODY            "PLF_APPLICATIONS_DML" 
 IS




    FUNCTION get_applications
    RETURN t_applications
    IS
       CURSOR cur_applications IS
         SELECT *
         FROM   applications;

       v_records   t_applications;
    BEGIN
       OPEN cur_applications;
           FETCH cur_applications BULK COLLECT INTO v_records;
       CLOSE cur_applications;
       RETURN v_records;
    END get_applications;

     FUNCTION get_application(p_strAppCode IN applications.app_code%TYPE)
        RETURN applications%ROWTYPE
        IS

           v_record applications%ROWTYPE;
        BEGIN
           SELECT *
           INTO   v_record
           FROM   applications
           WHERE  UPPER(app_code) = UPPER(p_strAppCode);
          
           RETURN v_record;
        END get_application;

   PROCEDURE create_application(p_strApplicationName IN APPLICATIONS.APPLICATION_NAME%TYPE,
                                p_strAppCode         IN APPLICATIONS.APP_CODE%TYPE,
                                p_intApplicationId   OUT APPLICATIONS.APPLICATION_ID%TYPE) IS

   BEGIN

      INSERT INTO APPLICATIONS
         (APPLICATION_ID, APPLICATION_NAME, APP_CODE)
      VALUES
         (seq_applications.NEXTVAL, p_strApplicationName, p_strAppCode)
      RETURNING application_id INTO p_intApplicationId;

   END create_application;

    PROCEDURE delete_application(p_intApplicationId IN APPLICATIONS.APPLICATION_ID%TYPE) IS
    BEGIN
       DELETE FROM APPLICATIONS WHERE APPLICATION_ID = p_intApplicationId;
    END delete_application;

    PROCEDURE update_application(p_intApplicationId   IN APPLICATIONS.APPLICATION_ID%TYPE,
                                 p_strApplicationName IN APPLICATIONS.APPLICATION_NAME%TYPE,
                                 p_strAppCode         IN APPLICATIONS.APP_CODE%TYPE) IS
    BEGIN
       UPDATE APPLICATIONS
          SET APPLICATION_NAME = p_strApplicationName,
              APP_CODE = p_strAppCode
        WHERE APPLICATION_ID = p_intApplicationId;
    END update_application;






 BEGIN
   NULL;
 END PLF_APPLICATIONS_DML;
 
/

ALTER PACKAGE "PLF_PROD"."PLF_APPLICATIONS_DML" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2014-12-17 06:58:10'
/
CREATE PACKAGE BODY            "PLF_EH" IS

     FUNCTION is_constraint RETURN BOOLEAN IS
         v_result BOOLEAN;
     BEGIN
         IF (REGEXP_INSTR(SQLERRM, 'constraint') > 0)
         THEN
             v_result := TRUE;
         ELSE
             v_result := FALSE;
         END IF;
    
         RETURN v_result;
    
     END is_constraint;

     FUNCTION user_defined_exception RETURN BOOLEAN IS
         v_result        BOOLEAN;
         c_strMatchSring VARCHAR2(60) := 'User-Defined Exception';
     BEGIN
         IF substr(SQLERRM, instr(SQLERRM, c_strMatchSring), length(c_strMatchSring)) =
            c_strMatchSring
         THEN
             v_result := TRUE;
         ELSE
             v_result := FALSE;
         END IF;
    
         RETURN v_result;
    
     END user_defined_exception;

     PROCEDURE create_error_table IS
         v_sql VARCHAR2(4000);
     BEGIN
         v_sql := 'CREATE TABLE "ERRLOG" 
                    ("ERRCODE" NUMBER(*,0), 
                 	"ERRMSG" VARCHAR2(4000), 
                 	"CREATED_ON" TIMESTAMP (6), 
                 	"CREATED_BY" VARCHAR2(100)
                    )';
         EXECUTE IMMEDIATE v_sql;
    
         v_sql := 'GRANT SELECT ON ERRLOG TO PUBLIC';
         EXECUTE IMMEDIATE v_sql;
    
     END create_error_table;


     FUNCTION build_nn_errmsg(p_strSqlErrm IN VARCHAR2) RETURN VARCHAR2 IS
         v_intStartIndex   PLS_INTEGER;
         v_intEndIndex     PLS_INTEGER;
         v_strColumnName   VARCHAR2(30);
         v_strDisplayName  VARCHAR2(30);
         v_strErrorMessage VARCHAR2(512);
     BEGIN
         v_intStartIndex := INSTR(p_strSqlErrm, '.', 1, 2);
         v_intEndIndex   := INSTR(p_strSqlErrm, ')', v_intStartIndex, 1);
         v_strColumnName := SUBSTR(p_strSqlErrm,
                                   v_intStartIndex + 1,
                                   (v_intEndIndex - v_intStartIndex) - 1);
    
         v_strDisplayName := INITCAP(REPLACE(v_strColumnName, '_', ' '));
    
         v_strErrorMessage := 'A value must be specified for ' || v_strDisplayName || '!';
    
         RETURN v_strErrorMessage;
     END build_nn_errmsg;

     FUNCTION get_user_message(p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE)
         RETURN ERROR_MESSAGES.USER_MESSAGE%TYPE IS
         v_msg ERROR_MESSAGES.USER_MESSAGE%TYPE;
     BEGIN
         IF (UPPER(p_strConditionName) = 'COLUMN_NOT_NULL_VIOLATION')
         THEN
             v_msg := build_nn_errmsg(SQLERRM);
         ELSE
             SELECT user_message
               INTO v_msg
               FROM error_messages t
              WHERE UPPER(t.condition_name) = UPPER(p_strConditionName);
         END IF;
    
         RETURN v_msg;
     END get_user_message;

     FUNCTION get_constraint(p_strErrorMessage IN VARCHAR2) RETURN VARCHAR2 IS
         v_startIndex     PLS_INTEGER;
         v_endIndex       PLS_INTEGER;
         v_constraintName VARCHAR2(30);
     BEGIN
         v_startIndex     := INSTR(p_strErrorMessage, '.', 1, 1);
         v_endIndex       := INSTR(p_strErrorMessage, ')', v_startIndex, 1);
         v_constraintName := SUBSTR(p_strErrorMessage,
                                    v_startIndex + 1,
                                    (v_endIndex - v_startIndex) - 1);
    
         RETURN v_constraintName;
     END get_constraint;

     PROCEDURE RaiseError IS
         v_intErrorCode    INTEGER;
         v_strErrorMessage VARCHAR2(4000);
         e_reraise EXCEPTION;
     BEGIN
         IF SQLCODE NOT IN (-20000, -20001)
         THEN
             v_strErrorMessage := dbms_utility.format_error_stack;
             v_intErrorCode    := c_int20001_ERROR_NUMBER;
             RAISE_APPLICATION_ERROR(v_intErrorCode, v_strErrorMessage);
         ELSE
             v_strErrorMessage := REPLACE(SQLERRM, 'ORA-20000:', '');
             v_intErrorCode    := SQLCODE;
             RAISE_APPLICATION_ERROR(v_intErrorCode, v_strErrorMessage);
         END IF;
    
     END RaiseError;

     PROCEDURE RaiseUserDefinedException(p_strErrorMsg IN st_ErrorMsg) IS
     BEGIN
         RAISE_APPLICATION_ERROR(c_int20000_ERROR_NUMBER, p_strErrorMsg, TRUE);
     END RaiseUserDefinedException;

     PROCEDURE RaiseSystemDefinedException(p_strException IN VARCHAR2) IS
         v_strMessage       VARCHAR2(4000);
         v_strConditionName error_messages.condition_name%TYPE := p_strException;
         c_COLUMN_NOT_NULL_VIOLATION CONSTANT VARCHAR2(400) := 'COLUMN_NOT_NULL_VIOLATION';
    
     BEGIN
         IF NOT user_defined_exception
         THEN
             IF p_strException != c_COLUMN_NOT_NULL_VIOLATION
             THEN
                 IF is_constraint
                 THEN
                     v_strConditionName := get_constraint(SQLERRM);
                 END IF;
             END IF;
         END IF;
    
         BEGIN
             v_strMessage := get_user_message(v_strConditionName);
         EXCEPTION
             WHEN OTHERS THEN
                 RaiseError;
         END;
    
         RaiseUserDefinedException(v_strMessage);
    
     END RaiseSystemDefinedException;


     PROCEDURE LogError(p_strErrorCode       IN VARCHAR2 := NULL,
                        p_strErrorMessage    IN VARCHAR2 := NULL,
                        p_strStackTrace      IN VARCHAR2 := NULL,
                        p_intApplicationId   IN VARCHAR2 := NULL,
                        p_strModule          IN VARCHAR2 := NULL,
                        p_strSessionID       IN VARCHAR2 := NULL,
                        p_strTarget          IN VARCHAR2 := NULL,
                        p_strTargetTableName IN VARCHAR2 := NULL,
                        p_strTargetDir       IN VARCHAR2 := NULL,
                        p_strTargetFile      IN VARCHAR2 := NULL,
                        p_intErrorID         OUT INTEGER) AS
    
         PRAGMA AUTONOMOUS_TRANSACTION;
    
         l_target            VARCHAR2(50) := NVL(p_strTarget, c_strTABLE);
         l_target_table_name VARCHAR2(100) := NVL(p_strTargetTableName,
                                                  c_strDEFAULT_LOG_TABLE);
         l_target_dir        VARCHAR2(32) := NVL(p_strTargetDir, c_strDEFAULT_LOG_DIR);
         l_target_file       VARCHAR2(32) := NVL(p_strTargetFile, c_strDEFAULT_LOG_FILE);
         l_log_identity      VARCHAR2(40) := USER || ' ' ||
                                             TO_CHAR(SYSDATE, 'mm/dd/yyyy hh24:mi:ss');
         l_error_code        errlog.ERROR_CODE%TYPE := nvl(p_strErrorCode, SQLCODE);
         l_error_message     errlog.error_message%TYPE := nvl(p_strErrorMessage, SQLERRM);
         l_stack_trace       VARCHAR2(32767) := nvl(p_strStackTrace,
                                                    dbms_utility.format_error_stack ||
                                                    chr(10) ||
                                                    dbms_utility.format_error_backtrace);   

         l_application_id    errlog.application_id%TYPE := p_intApplicationId;
         l_module            errlog.module%TYPE := p_strModule;
         l_session_id        errlog.session_id%TYPE := p_strSessionID;
    
         PROCEDURE LogToConsole(p_str IN VARCHAR2) IS
         BEGIN
             DBMS_OUTPUT.PUT_LINE(l_log_identity);
             DBMS_OUTPUT.PUT_LINE(p_str);
         END LogToConsole;
    
         PROCEDURE LogToTable IS
             v_sql VARCHAR2(4000);
             v_stack_trace CLOB;
         BEGIN
            v_stack_trace := to_clob(l_stack_trace);
             v_sql := 'INSERT INTO ' || l_target_table_name ||
                      ' (error_id, application_id, error_time, error_code, error_message, stack_trace, module, session_id) ' ||
                      'VALUES (seq_errlog.NEXTVAL,:application_id, SYSTIMESTAMP,:error_code,:error_message,:stack_trace,:module,:session_id) ' ||
                      'RETURNING error_id INTO :error_id';
             EXECUTE IMMEDIATE v_sql
                 USING l_application_id, l_error_code, l_error_message, v_stack_trace, l_module, l_session_id, OUT p_intErrorID;
        
         EXCEPTION
             WHEN OTHERS THEN
                 LogToConsole(l_stack_trace);
         END LogToTable;
    
         PROCEDURE LogToFile IS
             fid UTL_FILE.file_type;
         BEGIN
             fid := UTL_FILE.fopen(location     => l_target_dir,
                                   filename     => l_target_file,
                                   open_mode    => 'A',
                                   max_linesize => 4000);
             UTL_FILE.put_line(fid, l_log_identity);
             UTL_FILE.put_line(fid, l_error_message);
             UTL_FILE.fclose(fid);
         EXCEPTION
             WHEN UTL_FILE.INVALID_PATH THEN
                 DBMS_OUTPUT.PUT_LINE('Invalid Path ' || l_target_dir);
             WHEN UTL_FILE.INVALID_MODE THEN
                 DBMS_OUTPUT.PUT_LINE('Invalid Mode : A');
             WHEN UTL_FILE.INVALID_OPERATION THEN
                 DBMS_OUTPUT.PUT_LINE('Invalid Operation');
             WHEN OTHERS THEN
                 LogToTable;
                 UTL_FILE.fclose(fid);
         END LogToFile;
    
     BEGIN
         DBMS_OUTPUT.ENABLE(10000);
         IF l_target = c_strTABLE
         THEN
             LogToTable;
         ELSIF l_target = c_strFILE
         THEN
             LogToFile;
         ELSIF l_target = c_strCONSOLE
         THEN
             LogToConsole(SUBSTR(l_error_message, 1, 255));
         END IF;
         COMMIT;
    
     EXCEPTION
         WHEN OTHERS THEN
             ROLLBACK;
             LogToConsole(SUBSTR(l_error_message, 1, 255));
     END LogError;

     PROCEDURE LogError(p_strErrorCode       IN PLS_INTEGER := NULL,
                        p_strErrorMessage    IN VARCHAR2 := NULL,
                        p_strStackTrace      IN VARCHAR2 := NULL,
                        p_strModule          IN VARCHAR2 := NULL,
                        p_strSessionID       IN VARCHAR2 := NULL,
                        p_strTarget          IN VARCHAR2 := NULL,
                        p_strTargetTableName IN VARCHAR2 := NULL,
                        p_strTargetDir       IN VARCHAR2 := NULL,
                        p_strTargetFile      IN VARCHAR2 := NULL) AS
    
         v_error_id       errlog.error_id%TYPE;
         v_recApplication plf_applications_dml.rec_applicatoin;
     BEGIN
    
         v_recApplication := plf_applications_dml.get_application(c_SharpView_AppCode);
    
         logError(p_strErrorCode       => p_strErrorCode,
                  p_strErrorMessage    => p_strErrorMessage,
                  p_strStackTrace      => p_strStackTrace,
                  p_intApplicationId   => v_recApplication.application_id,
                  p_strModule          => p_strModule,
                  p_strSessionID       => p_strSessionID,
                  p_strTarget          => p_strTarget,
                  p_strTargetTableName => p_strTargetTableName,
                  p_strTargetDir       => p_strTargetDir,
                  p_strTargetFile      => p_strTargetFile,
                  p_intErrorID         => v_error_id);
    
     END LogError;

 END PLF_EH;
 
/

ALTER PACKAGE "PLF_PROD"."PLF_EH" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2013-05-11 02:17:36'
/
CREATE PACKAGE BODY            "PLF_ERROR_MESSAGES_DML" 
 IS




    PROCEDURE create_error_message(p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
                                   p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
                                   p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
                                   p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE,
                                   p_strCreatedBy     IN ERROR_MESSAGES.CREATED_BY%TYPE,
                                   p_intErrorCode     OUT ERROR_MESSAGES.ERROR_CODE%TYPE)
    IS
       v_recApplication   APPLICATIONS%ROWTYPE := PLF_APPLICATIONS_DML.GET_APPLICATION(p_strAppCode => p_strAppCode);
       v_intErrorCode     ERROR_MESSAGES.ERROR_CODE%TYPE;

       FUNCTION get_error_code(p_intApplicationId IN APPLICATIONS.APPLICATION_ID%TYPE)
       RETURN ERROR_MESSAGES.ERROR_CODE%TYPE IS
          v_intErrorCode ERROR_MESSAGES.ERROR_CODE%TYPE;
       BEGIN
          SELECT MAX(error_code) + 1 AS ec
            INTO v_intErrorCode
            FROM error_messages
           WHERE application_id = p_intApplicationId;

          IF   (v_intErrorCode IS NOT NULL)
          THEN
                RETURN v_intErrorCode;
          ELSE
                RAISE NO_DATA_FOUND;
          END IF;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
           RETURN 1250;
       END get_error_code;
    BEGIN
       v_intErrorCode := get_error_code(v_recApplication.Application_ID);
       INSERT INTO ERROR_MESSAGES
          (ERROR_CODE,
           APPLICATION_ID,
           CONDITION_NAME,
           USER_MESSAGE,
           HELP_TEXT,
           CREATED_BY,
           CREATE_DATE)
       VALUES
          (v_intErrorCode,
           v_recApplication.Application_Id,
           p_strConditionName,
           p_strUserMessage,
           p_strHelpText,
           p_strCreatedBy,
           SYSDATE)
       RETURNING error_code INTO p_intErrorCode;

    END create_error_message;

    PROCEDURE update_error_message(p_strAppCode       IN APPLICATIONS.APP_CODE%TYPE,
                                   p_intErrorCode     IN ERROR_MESSAGES.ERROR_CODE%TYPE,
                                   p_strConditionName IN ERROR_MESSAGES.CONDITION_NAME%TYPE,
                                   p_strUserMessage   IN ERROR_MESSAGES.USER_MESSAGE%TYPE,
                                   p_strHelpText      IN ERROR_MESSAGES.HELP_TEXT%TYPE)
    IS
    BEGIN
      UPDATE error_messages
      SET    condition_name = p_strConditionName,
             user_message   = p_strUserMessage,
             help_text      = p_strHelpText
      WHERE  ERROR_CODE     = p_intErrorCode
      AND    application_id = (SELECT application_id
                               FROM   applications
                               WHERE  UPPER(app_code) = UPPER(p_strAppCode)); 
    END update_error_message;
                                  

 BEGIN
   NULL;
 END plf_error_messages_dml;
 
/

ALTER PACKAGE "PLF_PROD"."PLF_ERROR_MESSAGES_DML" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:59:49'
/
CREATE PACKAGE BODY            "PLF_GRANTSCHEMAACCESS" IS

     FUNCTION isDBUser(p_user IN VARCHAR2) RETURN BOOLEAN IS
         v_result BOOLEAN;
         v_count  INTEGER;
     BEGIN
         plf_exc.AssertNotNull(p_User, 'User can not be NULL.');
         SELECT COUNT(*) INTO v_count FROM dba_users t WHERE username = UPPER(p_User);
    
         CASE
             WHEN v_count = 0 THEN
                 v_result := FALSE;
             ELSE
                 v_result := TRUE;
         END CASE;
         RETURN v_result;
    
     END isDBUser;

     FUNCTION isDBRole(p_role IN VARCHAR2) RETURN BOOLEAN IS
         v_result BOOLEAN;
         v_count  INTEGER;
     BEGIN
         plf_exc.AssertNotNull(p_Role, 'Role can not be NULL.');
         SELECT COUNT(*) INTO v_count FROM dba_roles t WHERE role = UPPER(p_Role);
    
         CASE
             WHEN v_count = 0 THEN
                 v_result := FALSE;
             ELSE
                 v_result := TRUE;
         END CASE;
         RETURN v_result;
    
     END isDBRole;
    
     FUNCTION isValidGrant(p_ObjectType IN VARCHAR2, p_Access IN VARCHAR2) RETURN BOOLEAN IS
         v_result BOOLEAN;
         v_count  INTEGER;
     BEGIN
         plf_exc.AssertNotNull(p_ObjectType, 'p_OBJECT can not be NULL.');
         plf_exc.AssertNotNull(p_Access, 'p_ACCESS can not be NULL.');
    
         plf_exc.Assert(UPPER(p_Access) IN
                        ('SELECT', 'INSERT', 'UPDATE', 'DELETE', 'EXECUTE', 'REFERENCES'),
                        'p_ACCESS must be one of SELECT,INSERT,UPDATE,DELETE,EXECUTE,REFERENCES');
         plf_exc.Assert(UPPER(p_ObjectType) IN ('TABLE', 'VIEW', 'MATERIALIZED VIEW', 'SEQUENCE',
                         'PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION'),
                        'p_ACCESS must be one of TABLE,VIEW,MATERIALIZED VIEW,SEQUENCE,PACKAGE,PACKAGE BODY,PROCEDURE,FUNCTION');
    
         SELECT COUNT(*)
           INTO v_count
           FROM swb_object_privs t
          WHERE t.object_type = UPPER(p_ObjectType)
            AND t.privilege = UPPER(p_Access);
    
         CASE
             WHEN v_count = 0 THEN
                 v_result := FALSE;
             ELSE
                 v_result := TRUE;
         END CASE;
         RETURN v_result;
    
     EXCEPTION
         WHEN OTHERS THEN
             PLF_EH.RaiseError;
        
     END isValidGrant;

     PROCEDURE GrantAccess(p_Grantor    IN VARCHAR2,
                           p_Grantee    IN VARCHAR2,
                           p_ObjectType IN VARCHAR2,
                           p_Access     IN VARCHAR2) IS
         v_sql VARCHAR2(4000);
     BEGIN
         IF NOT isDBUser(p_Grantor)
         THEN
             plf_eh.RaiseUserDefinedException('Grantor ' || p_Grantor ||
                                              ' does not exist!');
         END IF;
        
         IF NOT (isDBUser(p_Grantee) OR isDBRole(p_grantee))
         THEN
             plf_eh.RaiseUserDefinedException('Grantee ' || p_Grantee ||
                                              ' does not exist!');
         END IF;
        
         IF NOT isValidGrant(p_ObjectType, p_Access)
         THEN
             PLF_EH.RaiseUserDefinedException(p_ObjectType || '|' || p_Access ||
                                              ' is not a valid grant!');
         END IF;
    
         FOR cur_object_privs IN (SELECT object_type, privilege
                                    FROM swb_object_privs
                                   WHERE object_type = UPPER(p_ObjectType)
                                     AND privilege = UPPER(p_Access))
         LOOP
        
             FOR cur_objects IN (SELECT object_name
                                   FROM dba_objects
                                  WHERE owner = UPPER(p_Grantor)
                                    AND object_type = UPPER(p_ObjectType))
             LOOP
                 v_sql := 'GRANT ' || cur_object_privs.privilege || ' ON ' || p_Grantor || '.' ||
                          cur_objects.object_name || ' TO ' || p_Grantee;
                 dbms_output.put_line(v_sql);
                 EXECUTE IMMEDIATE v_sql;
            
             END LOOP;
        
         END LOOP;
    
     EXCEPTION
         WHEN OTHERS THEN
             PLF_EH.RaiseError;
     END;

     PROCEDURE RevokeAccess(p_Grantor    IN VARCHAR2,
                            p_Grantee    IN VARCHAR2,
                            p_ObjectType IN VARCHAR2,
                            p_Access     IN VARCHAR2) IS
         v_sql VARCHAR2(4000);
     BEGIN
         IF NOT isDBUser(p_Grantor)
         THEN
             plf_eh.RaiseUserDefinedException('Grantor ' || p_Grantor ||
                                              ' does not exist!');
         END IF;
    
         IF NOT isDBUser(p_Grantee)
         THEN
             plf_eh.RaiseUserDefinedException('Grantee ' || p_Grantee ||
                                              ' does not exist!');
         END IF;
    
         IF NOT isValidGrant(p_ObjectType, p_Access)
         THEN
             PLF_EH.RaiseUserDefinedException(p_ObjectType || '|' || p_Access ||
                                              ' is not a valid grant!');
         END IF;
    
         FOR cur_object_privs IN (SELECT object_type, privilege
                                    FROM swb_object_privs s
                                   WHERE object_type = UPPER(p_ObjectType)
                                     AND privilege = UPPER(p_Access))
         LOOP
        
             FOR cur_objects IN (SELECT object_name
                                   FROM dba_objects o, dba_tab_privs p
                                  WHERE o.owner = p.owner
                                    AND o.object_name = p.table_name
                                    AND o.owner = UPPER(p_Grantor)
                                    AND p.grantee = UPPER(p_Grantee)
                                    AND object_type = UPPER(p_ObjectType))
             LOOP
                 v_sql := 'REVOKE ' || cur_object_privs.privilege || ' ON ' || p_Grantor || '.' ||
                          cur_objects.object_name || ' FROM ' || p_Grantee;
                 EXECUTE IMMEDIATE v_sql;
            
             END LOOP;
        
         END LOOP;
    
     EXCEPTION
         WHEN OTHERS THEN
             PLF_EH.RaiseError;
     END;

 END PLF_GrantSchemaAccess;
 
/

ALTER PACKAGE "PLF_PROD"."PLF_GRANTSCHEMAACCESS" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2014-12-17 06:58:10'
/
CREATE PACKAGE BODY            "PLF_METADATA" 
  IS


  
   PROCEDURE load IS
       v_intId  NUMBER;
    BEGIN
    
    
      PLF_APPLICATIONS_DML.CREATE_APPLICATION(p_strApplicationName => 'SharpView',
  	                                         p_strAppCode         => 'SV',
  					                             p_intApplicationId   => v_intId)  ;                                                                            
                 
                                                                               
                               
    COMMIT;
                                                     
    END load;
  
    PROCEDURE sync IS
    BEGIN
      NULL;
    END sync;
  
    PROCEDURE reset IS
    BEGIN
      NULL;
    END reset;
  

  BEGIN
    NULL;
  END plf_metadata;
 
 
/

ALTER PACKAGE "PLF_PROD"."PLF_METADATA" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  FALSE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2011-09-03 06:59:47'
/
CREATE PACKAGE BODY PLF_UTIL AS

    -------------------------------------------------------------------------
    -------------------------------------------------------------------------
    -- PRIVATE PROCEDURES/FUNCTIONS
    -------------------------------------------------------------------------
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -------------------------------------------------------------------------
    -- PUBLIC PROCEDURES/FUNCTIONS
    -------------------------------------------------------------------------
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- General routines
    -------------------------------------------------------------------------
    PROCEDURE pl(p_strOutput IN VARCHAR2, p_piLen IN PLS_INTEGER := 80) IS
        v_str VARCHAR2(2000);
    BEGIN
        IF LENGTH(p_strOutput) > p_piLen
        THEN
            v_str := SUBSTR(p_strOutput, 1, p_piLen);
            DBMS_OUTPUT.PUT_LINE(v_str);

            -- Recursive call to output remaining string
            pl(SUBSTR(p_strOutput, p_piLen + 1), p_piLen);

        ELSE
            v_str := p_strOutput;
            DBMS_OUTPUT.PUT_LINE(v_str);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.ENABLE(1000000);
            DBMS_OUTPUT.PUT_LINE(v_str);
    END pl;

    -------------------------------------------------------------------------
    -- String manipulation routines
    -------------------------------------------------------------------------
    FUNCTION strInitString(p_piStringSize IN PLS_INTEGER,
                           p_strInit      IN VARCHAR2) RETURN VARCHAR2 IS
        c_piMAX_STRING PLS_INTEGER := 4096;

        v_strTemp VARCHAR2(4096) := '';
        v_strInit VARCHAR2(1);
        v_piMax   PLS_INTEGER;

    BEGIN

        -- Check the init string
        IF LENGTH(p_strInit) = 0
        THEN
            v_strInit := ' ';
        ELSE
            -- Use the first character only
            v_strInit := SUBSTR(p_strInit, 1);
        END IF;

        IF p_piStringSize > c_piMAX_STRING OR p_piStringSize <= 0
        THEN
            v_piMax := c_piMAX_STRING;
        ELSE
            v_piMax := p_piStringSize;
        END IF;

        -- Build string
        FOR n2 IN 1 .. v_piMax
        LOOP
            v_strTemp := v_strTemp || v_strInit;
        END LOOP;

        -- Return
        RETURN v_strTemp;

    END strInitString;

    -------------------------------------------------------------------------
    FUNCTION strConcatString(p_str1     IN VARCHAR2,
                             p_str2     IN VARCHAR2,
                             p_strDelim IN VARCHAR2 := PLF_CONST.c_strCRLF)
        RETURN VARCHAR2 IS
    BEGIN
        RETURN p_str1 || p_strDelim || p_str2;
    END strConcatString;

    -------------------------------------------------------------------------
    PROCEDURE SendMail(p_strSender    IN VARCHAR2,
                       p_strRecipient IN VARCHAR2,
                       p_strSubject   IN VARCHAR2,
                       p_strBody      IN VARCHAR2)

     IS
        v_strServer VARCHAR2(64) := 'mail.sharpanalytics.com'; --Name or IP of SMTP server
        v_strDomain VARCHAR2(64) := 'sharpanalytics.com'; --Domain name

        c utl_smtp.connection; --create connection

        PROCEDURE send_header(NAME IN VARCHAR2, header IN VARCHAR2) AS
        BEGIN
            utl_smtp.write_data(c, NAME || ': ' || header || utl_tcp.CRLF);
        END;

    BEGIN
        c := utl_smtp.open_connection(v_strServer); --open port to smtp server
        utl_smtp.helo(c, v_strDomain); --establish domain I'm coming from
        utl_smtp.mail(c, p_strSender); --who is sending
        utl_smtp.rcpt(c, p_strRecipient); --recipient
        utl_smtp.open_data(c);
        send_header('From', p_strSender);
        send_header('To', p_strRecipient);
        send_header('Subject', p_strSubject);
        utl_smtp.write_data(c, utl_tcp.CRLF || p_strBody); --email message per RFC 821
        utl_smtp.close_data(c);
        utl_smtp.quit(c);

    EXCEPTION
        WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
            BEGIN
                utl_smtp.quit(c);
            EXCEPTION
                WHEN utl_smtp.transient_error OR utl_smtp.permanent_error THEN
                    NULL; -- When the SMTP server is down or unavailable, we don't have
                -- a connection to the server. The quit call will raise an
                -- exception that we can ignore.
            END;
            PLF_EH.LogError; -- Record error
            RAISE; -- Propagate error to top calling routine

        WHEN OTHERS THEN
            PLF_EH.LogError; -- Record error
            RAISE; -- Propagate error to top calling routine

            raise_application_error(-20000,
                                    'Failed to send mail due to the following error: ' ||
                                    SQLERRM);
    END SendMail;

    -------------------------------------------------------------------------
    FUNCTION CloseCursor(p_strCursor IN OUT VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        IF DBMS_SQL.IS_OPEN(p_strCursor)
        THEN
            DBMS_SQL.CLOSE_CURSOR(p_strCursor);
            RETURN TRUE;
        END IF;

        RETURN FALSE;

    EXCEPTION
        WHEN OTHERS THEN
            PLF_EH.LogError; -- Record error
            RAISE; -- Propagate error to top calling routine

    END CloseCursor;

    -------------------------------------------------------------------------
    FUNCTION GetDBName RETURN VARCHAR2 IS
        v_strReturn VARCHAR2(32);

    BEGIN
        SELECT global_name
          INTO v_strReturn
          FROM global_name;

        RETURN v_strReturn;

    EXCEPTION
        WHEN OTHERS THEN
            PLF_EH.LogError; -- Record error
            RAISE; -- Propagate error to top calling routine

    END GetDBName;

    -------------------------------------------------------------------------------
    FUNCTION CSVToTable(p_strCSV IN VARCHAR2) RETURN DBMS_SQL.Varchar2_Table IS

        t_Table            DBMS_SQL.Varchar2_Table;
        v_strComma         CHAR(1) := ',';
        v_intNumCommas     INTEGER;
        v_strCSV           VARCHAR2(32000);
        v_intStartPosition INTEGER;
        v_intLength        INTEGER;
        v_intValue         VARCHAR2(255);

    BEGIN

        -- need preceeding comma to get counts right
        v_strCSV := ',' || TRIM(',' FROM p_strCSV) || ',';

        -- Divide difference of two lengths by length of substring.
        v_intNumCommas := (((length(v_strCSV) -
                          nvl(length(REPLACE(v_strCSV, v_strComma)), 0)) /
                          length(v_strComma)));

        FOR i IN 1 .. (v_intNumCommas - 1)
        LOOP

            v_intStartPosition := INSTR(v_strCSV, v_strComma, 1, i) + 1;
            v_intLength := INSTR(v_strCSV, v_strComma, 1, i + 1) -
                           v_intStartPosition;
            v_intValue := SUBSTR(v_strCSV, v_intStartPosition, v_intLength);
            t_Table(i) := SUBSTR(v_strCSV, v_intStartPosition, v_intLength);

        END LOOP;

        RETURN t_Table;

    END CSVToTable;

    -------------------------------------------------------------------------------
    FUNCTION WriteDelimited(p_strQuery     IN VARCHAR2,
                            p_strSeperator IN VARCHAR2,
                            p_strDirectory IN VARCHAR2,
                            p_strFileName  IN VARCHAR2)
    RETURN NUMBER
    IS
        l_output      utl_file.file_type;
        l_theCursor   INTEGER DEFAULT dbms_sql.open_cursor;
        l_columnValue VARCHAR2(2000);
        l_status      INTEGER;
        l_colCnt      NUMBER DEFAULT 0;
        l_seperator   VARCHAR2(10) DEFAULT '';
        l_cnt         NUMBER DEFAULT 0;

    BEGIN
        l_output := utl_file.fopen(p_strDirectory,
                                   p_strFileName,
                                   'w',
                                   32000);

        dbms_sql.parse(l_theCursor, p_strQuery, dbms_sql.native);

        FOR i IN 1 .. 255
        LOOP
            BEGIN
                dbms_sql.define_column(l_theCursor, i, l_columnValue, 2000);
                l_colCnt := i;
            EXCEPTION
                WHEN OTHERS THEN
                    IF (SQLCODE = -1007)
                    THEN
                        EXIT;
                    ELSE
                        RAISE;
                    END IF;
            END;
        END LOOP;

        dbms_sql.define_column(l_theCursor, 1, l_columnValue, 2000);

        l_status := dbms_sql.EXECUTE(l_theCursor);

        LOOP
            EXIT WHEN(dbms_sql.fetch_rows(l_theCursor) <= 0);
            l_seperator := '';
            FOR i IN 1 .. l_colCnt
            LOOP
                dbms_sql.column_value(l_theCursor, i, l_columnValue);
                utl_file.put(l_output, l_seperator || l_columnValue);
                l_seperator := p_strSeperator;
            END LOOP;
            utl_file.new_line(l_output);
            l_cnt := l_cnt + 1;
        END LOOP;
        dbms_sql.close_cursor(l_theCursor);

        utl_file.fclose(l_output);
        RETURN l_cnt;

    EXCEPTION
        WHEN OTHERS THEN
            PLF_EH.LogError; -- Record error
            RAISE;

    END WriteDelimited;

    -------------------------------------------------------------------------------
    FUNCTION WriteFixed(p_strQuery         IN VARCHAR2,
                        p_strColumnLengths IN VARCHAR2,
                        p_strDirectory     IN VARCHAR2,
                        p_strFileName      IN VARCHAR2) RETURN NUMBER
    IS
        l_output       utl_file.file_type;
        l_max_linesize NUMBER := 32000;
        l_theCursor    INTEGER DEFAULT dbms_sql.open_cursor;
        l_columnValue  VARCHAR2(4000);
        l_status       INTEGER;
        l_colCnt       NUMBER DEFAULT 0;
        l_cnt          NUMBER DEFAULT 0;
        l_line         LONG;
        l_descTbl      dbms_sql.desc_tab;
        v_tColSizes    dbms_sql.Varchar2_Table;

    BEGIN
        l_output := utl_file.fopen(p_strDirectory,
                                   p_strFileName,
                                   'w',
                                   l_max_linesize);

        dbms_sql.parse(l_theCursor, p_strQuery, dbms_sql.native);
        dbms_sql.describe_columns(l_theCursor, l_colCnt, l_descTbl);
        -- read column_lengths into an assoc table array
        v_tColSizes := CSVToTable(p_strColumnLengths);

        -- loop through column_lenghts matching with each column of cursor
        -- if colCount != Number of columns then raise exception!

        FOR i IN 1 .. l_colCnt
        LOOP
            dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
            L_descTbl(i).col_max_len := v_tColSizes(i);
        END LOOP;

        l_status := dbms_sql.EXECUTE(l_theCursor);

        LOOP
            EXIT WHEN(dbms_sql.fetch_rows(l_theCursor) <= 0);
            l_line := NULL;
            FOR i IN 1 .. l_colCnt
            LOOP
                dbms_sql.column_value(l_theCursor, i, l_columnValue);
                l_line := l_line ||
                          rpad(nvl(l_columnValue, ' '),
                               l_descTbl(i).col_max_len);
            END LOOP;
            utl_file.put_line(l_output, l_line);
            l_cnt := l_cnt + 1;
        END LOOP;
        dbms_sql.close_cursor(l_theCursor);
        utl_file.fclose(l_output);
        RETURN l_cnt;
    END WriteFixed;

    
    ----------------------------------------------------
    
    function GetETSyntax(p_tabStmt                 IN OUT dbms_sql.varchar2s,
                         p_strClause               IN VARCHAR2,
                         p_strTableName            IN VARCHAR2,
                         p_strLocation             IN VARCHAR2, -- filename
                         p_strDefaultDirectory     IN VARCHAR2,
                         p_strRecordsDelimtedBy    IN VARCHAR2,
                         p_strCharacterSet         IN VARCHAR2,
                         p_intSkip                 IN INTEGER,
                         p_strFieldsTerminatedBy   IN VARCHAR2,
                         p_strOptionallyEnclosedBy IN VARCHAR2,
                         p_strMissingFieldValues   IN VARCHAR2,
                         p_strTrim                 IN VARCHAR2)
      return dbms_sql.varchar2s is
    begin
      case p_strClause
        when 'HEADER' then
          -- Header
          p_tabStmt(p_tabStmt.count + 1) := 'CREATE TABLE ' ||
                                            p_strTableName || ' (';
        
        when 'LOAD PARAMETERS' then
        
          -- Load parameters
          p_tabStmt(p_tabStmt.count + 1) := ') ORGANIZATION EXTERNAL (TYPE ORACLE_LOADER DEFAULT DIRECTORY ' ||
                                            p_strDefaultDirectory;
          p_tabStmt(p_tabStmt.count + 1) := ' ACCESS PARAMETERS (RECORDS DELIMITED BY ' ||
                                            p_strRecordsDelimtedBy;
        WHEN 'CHARACTERSET' THEN
             IF p_strCharacterSet IS NOT NULL THEN
            p_tabStmt(p_tabStmt.count + 1) := ' CHARACTERSET ' || p_strCharacterSet;
          END IF;
        
        when 'SKIP' then
          -- Skip?
          IF p_intSkip IS NOT NULL THEN
            p_tabStmt(p_tabStmt.count + 1) := ' SKIP ' || p_intSkip;
          END IF;
        
        when 'FIELD DELIMETER' then
          -- Field Delimeter
          IF p_strFieldsTerminatedBy IS NULL THEN
            p_tabStmt(p_tabStmt.count + 1) := ' FIELDS ';
          ELSE
            p_tabStmt(p_tabStmt.count + 1) := ' FIELDS TERMINATED BY "' ||
                                              p_strFieldsTerminatedBy || '" ';
          END IF;
        
        when 'ENCLOSED BY' then
          -- Enclosed by
          IF p_strOptionallyEnclosedBy IS NOT NULL THEN
            p_tabStmt(p_tabStmt.count + 1) := ' OPTIONALLY ENCLOSED BY ''' ||
                                              p_strOptionallyEnclosedBy ||
                                              ''' ';
          END IF;
        
        when 'TRIM' then
          -- Trim
          p_tabStmt(p_tabStmt.count + 1) := p_strTrim;
        
        when 'MISSING FIELD VALUES' then
          -- Missing field values
          p_tabStmt(p_tabStmt.count + 1) := ' MISSING FIELD VALUES ARE ' ||
                                            p_strMissingFieldValues || ' (';
        
        when 'LOCATION' then
          -- Location
        p_tabStmt(p_tabStmt.count+1) := ')) LOCATION (''' || p_strLocation || '''))  REJECT LIMIT UNLIMITED';

        
      end case;
      return p_tabStmt;
      
      EXCEPTION
      WHEN OTHERS THEN
        PLF_EH.RaiseError;
        
    end GetETSyntax;
    
    -------------------------------------------------------------------------------------------
    PROCEDURE ExternalTable(p_strTableName          IN VARCHAR2,
                            p_strLocation           IN VARCHAR2,
                            p_strDefaultDirectory   IN VARCHAR2,
                            p_tabFields             IN t_Fields,
                            p_strRecordsDelimtedBy  IN VARCHAR2,
                            p_strCharacterSet       IN VARCHAR2,
                            p_intSkip               IN INTEGER,
                            p_strFieldsTerminatedBy IN VARCHAR2,
                            p_strOptionallyEnclosedBy IN VARCHAR2,
                            p_strMissingFieldValues IN VARCHAR2,
                            p_strTrim               IN VARCHAR2) 
    IS
        l_stmt   dbms_sql.varchar2s;  -- 256 per line
        l_cursor integer default dbms_sql.open_cursor;
        v_colname         VARCHAR2(32000);
        v_fieldname       VARCHAR2(32000);
        v_comma           VARCHAR2(1);
        v_dtype           VARCHAR2(32);
        indx              NUMBER;
        v_strSQL          VARCHAR2(4000);
        

        CURSOR c_DropTab IS
            SELECT owner||'.'||table_name
              FROM all_tables
             WHERE upper(owner||'.'||table_name) = UPPER(p_strTableName);

    BEGIN
        -- Drop table if already exists.
        FOR v_tabname IN c_DropTab
        LOOP
            IF c_DropTab%FOUND
            THEN
                v_strSQL := 'DROP TABLE ' || p_strTableName;
                EXECUTE IMMEDIATE v_strSQL;
            END IF;
        END LOOP;
             
        -- Header
        l_stmt := GetETSyntax(l_stmt,'HEADER',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
          
        -- Build up column names syntax
        indx := p_tabFields.FIRST;
        LOOP
            EXIT WHEN indx IS NULL;

            CASE p_tabFields(indx).field_datatype
                WHEN 'CHAR' THEN
                    v_dtype := 'VARCHAR2';
                WHEN 'RECNUM' THEN
                    v_dtype := 'INTEGER';
                ELSE
                    v_dtype := p_tabFields(indx).field_datatype;
            END CASE;

            CASE
                WHEN p_tabFields(indx).field_length IS NULL THEN
                    v_colname := plf_util.escapeForOracleObjectName(
                                   p_tabFields(indx).field_name
                                 ) || ' ' || v_dType;
                ELSE
                    v_colname := plf_util.escapeForOracleObjectName(
                                   p_tabFields(indx).field_name
                                 ) || ' ' || v_dType || '(' ||
                                 p_tabFields(indx).field_length || ')';
            END CASE;

            IF indx = p_tabFields.FIRST
            THEN
                v_comma := '';
            ELSE
                v_comma := ',';
            END IF;

            l_stmt(l_stmt.count+1) := v_comma || v_colname;

            indx := p_tabFields.NEXT(indx);
        END LOOP;
        
        l_stmt := GetETSyntax(l_stmt,'LOAD PARAMETERS',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

        l_stmt := GetETSyntax(l_stmt,'CHARACTERSET',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);                        
    
        l_stmt := GetETSyntax(l_stmt,'SKIP',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
        l_stmt := GetETSyntax(l_stmt,'FIELD DELIMETER',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
        l_stmt := GetETSyntax(l_stmt,'ENCLOSED BY',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
        l_stmt := GetETSyntax(l_stmt,'TRIM',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
        l_stmt := GetETSyntax(l_stmt,'MISSING FIELD VALUES',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
        -- Build up field definition syntax
        indx := p_tabFields.FIRST;
        LOOP
            EXIT WHEN indx IS NULL;

            v_fieldname := plf_util.escapeForOracleObjectName(p_tabFields(indx).field_name) || ' ';

            IF p_strFieldsTerminatedBy IS NULL
            THEN
                CASE
                    WHEN ((p_tabFields(indx).field_begin IS NULL) AND
                         (p_tabFields(indx).field_end IS NULL)) THEN
                        v_fieldname := v_fieldname;
                    ELSE
                        v_fieldname := v_fieldname || '(' ||
                                       p_tabFields(indx).field_begin || ':' ||
                                       p_tabFields(indx).field_end || ')';
                END CASE; END IF;

            -- convert to access parameter datatypes
            CASE p_tabFields(indx).field_datatype
                WHEN 'CHAR' THEN
                    v_dtype := 'CHAR';
                WHEN 'RECNUM' THEN
                    v_dtype := 'RECNUM';
                WHEN 'INTEGER' THEN
                    v_dtype := 'CHAR';  -- or INTEGER EXTERNAL
                WHEN 'NUMBER' THEN
                    v_dtype := 'CHAR';
                ELSE
                    v_dtype := p_tabFields(indx).field_datatype;
            END CASE;

            CASE
                WHEN p_tabFields(indx).field_length IS NULL THEN
                    v_fieldname := v_fieldname || ' ' || v_dtype;
                ELSE
                    v_fieldname := v_fieldname || ' ' || v_dtype || '(' ||
                                   p_tabFields(indx).field_length || ')';
            END CASE;

            IF indx = p_tabFields.FIRST
            THEN
                v_comma := '';
            ELSE
                v_comma := ',';
            END IF;

            l_stmt(l_stmt.count+1) :=  v_comma || v_fieldname;

            indx := p_tabFields.NEXT(indx);
        END LOOP;        
        
        l_stmt := GetETSyntax(l_stmt,'LOCATION',p_strTableName,p_strLocation, p_strDefaultDirectory,
                          p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                          p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
                       
        /*
        indx := l_stmt.first;
        while indx is not null 
        loop
          pl(l_stmt(indx));  
          indx := l_stmt.next(indx);
        end loop;
        */
        
        -- Execute SQL
        dbms_sql.parse(c             => l_cursor,
                       statement     => l_stmt,
                       lb            => l_stmt.first,
                       ub            => l_stmt.last,
                       lfflg         => TRUE,
                       language_flag => dbms_sql.native);
      
        dbms_sql.close_cursor(l_cursor);

    EXCEPTION
      WHEN OTHERS THEN
        PLF_EH.RaiseError;

    END ExternalTable;

    --------------------------------------------------------------------
    FUNCTION isdate(p_str IN VARCHAR2, p_format VARCHAR2) RETURN DATE IS
    BEGIN
      RETURN to_date(p_str,p_format);
    EXCEPTION
      WHEN OTHERS THEN
        RETURN NULL;
    END;
    
    ----------------------------------------------------------------------
    -- Escape function for inserting strings into oracle tables
    FUNCTION escapeForOracle(p_str IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
      RETURN REPLACE(p_str, '''', '''''');
    EXCEPTION
      WHEN OTHERS THEN
        plf_eh.logError;
        RETURN p_str;
    END escapeForOracle;
    
    ----------------------------------------------------------------------
    -- Escape function for creating valid Oracle obejct names
    FUNCTION escapeForOracleObjectName(p_str IN VARCHAR2) RETURN VARCHAR2 IS
      v_str VARCHAR2(32000) := p_str;
    BEGIN
      
      -- Get rid of spaces on the ends
      v_str := TRIM(v_str);
      -- make sure first character is a letter
      IF isNumber(SUBSTR(v_str,1,1)) THEN
        v_str := 'a'||v_str;
      END IF;
      -- escape invalid characters
      v_str := TRANSLATE(v_str, ' ~!@%^&*()-+=\\/|][}{?.,><''";:`','_');
      -- truncate length at maximum length
      IF LENGTH(v_str) > 30 THEN
        v_str := SUBSTR(v_str, 1, 30);
      END IF;
      RETURN v_str;
    EXCEPTION
      WHEN OTHERS THEN
        plf_eh.logError;
        RETURN p_str;
    END escapeForOracleObjectName;
    
    -------------------------------------------------------------------------
    -- IsNumber function
    -------------------------------------------------------------------------
    FUNCTION isNumber(p_str IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
      IF NVL(LENGTH(TRANSLATE(TRIM(p_str),' +-.0123456789',' ')),0) = 0 THEN
        RETURN TRUE;
      ELSE
        RETURN FALSE;
      END IF;
    END ISNUMBER;
    
    -------------------------------------------------------------------------
    -- Validation routines
    -------------------------------------------------------------------------
    FUNCTION bIsNumber(p_strIn IN VARCHAR2) RETURN BOOLEAN IS
        v_Num NUMBER;
    BEGIN
        v_Num := TO_NUMBER(p_strIn);
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END bIsNumber;
    
    --------------------------------------------------------------------------
    FUNCTION Parse256(p_strIn IN VARCHAR2) RETURN dbms_sql.varchar2s IS
      v_tabStr          dbms_sql.varchar2s;
      v_intPosition     INTEGER := 1;
      v_intLength       INTEGER;
      v_intLastPlace    INTEGER := 1;
      i                 INTEGER := 1;
      c_space           CHAR := ' ';
    BEGIN
      v_intLength := LENGTH(p_strIn);
    
      IF v_intLength < 257 THEN
        v_tabStr(nvl(v_tabStr.LAST, 0) + 1) := p_strIn;
      ELSE
      
        LOOP
          EXIT WHEN v_intPosition > v_intLength;
        
          IF v_intPosition > 250*i THEN  -- 250 to be safe
            v_tabStr(nvl(v_tabStr.LAST, 0) + 1) := substr(p_strIn,
                                                          v_intLastPlace,
                                                          (v_intPosition - v_intLastPlace));
            v_intLastPlace := v_intPosition;
            i := i + 1;
          END IF;
          v_intPosition := v_intPosition + 1;
        END LOOP;
      
        v_tabStr(nvl(v_tabStr.LAST, 0) + 1) := substr(p_strIn,
                                                      v_intLastPlace,
                                                      (v_intPosition - v_intLastPlace));
      END IF;
    
      RETURN v_tabStr;
    
    EXCEPTION
      WHEN OTHERS THEN
        plf_eh.logError;
        RETURN v_tabStr;
      
    END Parse256;

     --------------------------------------------------------------------
    FUNCTION FixFields(p_tabFields IN DBMS_SQL.Varchar2_Table)
      RETURN DBMS_SQL.Varchar2_Table IS
      i           integer;
      j           integer := 1;
      v_tabFields DBMS_SQL.Varchar2_Table;
    BEGIN
      i := p_tabFields.FIRST;
      LOOP
        EXIT WHEN i IS NULL;
        -- remove punctuation etc.
                v_tabFields(i) := p_tabFields(i);
                v_tabFields(i) := regexp_replace(v_tabFields(i),'([#]){1,}','NUM');
                v_tabFields(i) := regexp_replace(v_tabFields(i),'([%]){1,}','PCT');
                v_tabFields(i) := regexp_replace(v_tabFields(i),'([[:punct:]])','');
                v_tabFields(i) := regexp_replace(v_tabFields(i),'( ){1,}','_',1,0,'i');
                v_tabFields(i) := regexp_replace(v_tabFields(i),'(_){2,}','_',1,0,'i');
        if length(v_tabFields(i)) > 30 then
          -- shorten it
          v_tabFields(i) := substr(v_tabFields(i), 1, 28) || to_char(j);
          j := j + 1;
        end if;
        i := p_tabFields.NEXT(i);
      END LOOP;
    
      RETURN v_tabFields;
    
    EXCEPTION
      WHEN OTHERS THEN
        PLF_EH.RaiseError;
      
    END FixFields;

    --------------------------------------------------------------------
    PROCEDURE Fast_ET(p_strTableName            IN VARCHAR2,
                      p_strLocation             IN VARCHAR2,  -- filename
                      p_strDefaultDirectory     IN VARCHAR2,
                      p_strFields               IN VARCHAR2,
                      p_strRecordsDelimtedBy    IN VARCHAR2,
                      p_strCharacterSet         IN VARCHAR2,
                      p_intSkip                 IN INTEGER,
                      p_strFieldsTerminatedBy   IN VARCHAR2,
                      p_strOptionallyEnclosedBy IN VARCHAR2,
                      p_strMissingFieldValues   IN VARCHAR2,
                      p_strTrim                 IN VARCHAR2,
                      p_bHeader                 IN BOOLEAN) IS

    l_max_linesize    NUMBER := 32000;
    v_tabfields       DBMS_SQL.Varchar2_Table;
    v_strFields       VARCHAR2(32000);
    v_comma           VARCHAR2(1);
    indx              NUMBER;
    v_strSQL          VARCHAR2(32000);
    l_output          utl_file.file_type;
    l_line            VARCHAR2(32000);
    
    l_stmt   dbms_sql.varchar2s;  -- 256 per line
    l_cursor integer default dbms_sql.open_cursor;
    
    c_intFixedColLength integer := 4000;
    
    CURSOR c_DropTab IS
      SELECT table_name
        FROM user_tables
       WHERE table_name = UPPER(p_strTableName);

  BEGIN
    -- Drop table if already exists.
    FOR v_tabname IN c_DropTab LOOP
      IF c_DropTab%FOUND THEN
        v_strSQL := 'DROP TABLE ' || p_strTableName;
        EXECUTE IMMEDIATE v_strSQL;
      END IF;
    END LOOP;

    -- get header fields
    IF p_bHeader THEN -- get header fields from file
            l_output := utl_file.fopen(p_strDefaultDirectory,
                                       p_strLocation,
                                       'r',
                                       l_max_linesize);
            utl_file.get_line(l_output, l_line,l_max_linesize);
            utl_file.fclose(l_output);
            v_strFields := replace(l_line,'"'); -- remove quotes
            v_strFields := replace(v_strFields,p_strFieldsTerminatedBy,','); -- convert delimiter to comma
    ELSE              -- get headers from parameters
            v_strFields := p_strFields;
    END IF;

    -- Convert csv to table
    v_tabFields := plf_util.CSVToTable(v_strFields);

    -- cleanup fields, too long, etc.
    v_tabFields := FixFields(v_tabFields);

    -- Header
    l_stmt := GetETSyntax(l_stmt,'HEADER',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
          
    -- Build up column names syntax                   
    indx        := v_tabFields.FIRST;
    LOOP
      EXIT WHEN indx IS NULL;
      IF indx = v_tabFields.FIRST THEN
        v_comma := '';
      ELSE
        v_comma := ',';
      END IF;
      
      l_stmt(l_stmt.count+1) := v_comma || v_tabFields(indx) || ' VARCHAR2(' || c_intFixedColLength ||')';

      indx := v_tabFields.NEXT(indx);
    END LOOP;

    l_stmt := GetETSyntax(l_stmt,'LOAD PARAMETERS',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

    l_stmt := GetETSyntax(l_stmt,'SKIP',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

    l_stmt := GetETSyntax(l_stmt,'FIELD DELIMETER',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

    l_stmt := GetETSyntax(l_stmt,'ENCLOSED BY',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

    l_stmt := GetETSyntax(l_stmt,'TRIM',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);

    l_stmt := GetETSyntax(l_stmt,'MISSING FIELD VALUES',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
    
    -- Build up field definition syntax
        indx        := v_tabFields.FIRST;
    LOOP
      EXIT WHEN indx IS NULL;
      IF indx = v_tabFields.FIRST THEN
        v_comma := '';
      ELSE
        v_comma := ',';
      END IF;
      l_stmt(l_stmt.count+1) := v_comma || v_tabFields(indx) || ' CHAR(' || c_intFixedColLength ||')';
      indx := v_tabFields.NEXT(indx);
    END LOOP;

    l_stmt := GetETSyntax(l_stmt,'LOCATION',p_strTableName,p_strLocation, p_strDefaultDirectory,
                      p_strRecordsDelimtedBy,p_strCharacterSet,p_intSkip,p_strFieldsTerminatedBy,
                      p_strOptionallyEnclosedBy,p_strMissingFieldValues,p_strTrim);
        
    -- Execute SQL
/*    indx := l_stmt.first;
    while indx is not null 
    loop
      dbms_output.put_line(l_stmt(indx));
      indx := l_stmt.next(indx);
    end loop;
    */
    dbms_sql.parse(c             => l_cursor,
                   statement     => l_stmt,
                   lb            => l_stmt.first,
                   ub            => l_stmt.last,
                   lfflg         => TRUE,
                   language_flag => dbms_sql.native);
  
    dbms_sql.close_cursor(l_cursor);        

  EXCEPTION
    WHEN OTHERS THEN
      PLF_EH.RaiseError;
  END Fast_ET;

  -----------------------------------------------------------------------------------------
  FUNCTION isNumeric(p_str VARCHAR2) RETURN VARCHAR2 IS
      l_test_number NUMBER;
  BEGIN
      l_test_number := p_str;
      RETURN 'TRUE';
  EXCEPTION
      WHEN OTHERS THEN
          RETURN 'FALSE';
  END;



END PLF_UTIL;
/

ALTER PACKAGE "PLF_PROD"."PLF_UTIL" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

 REUSE SETTINGS TIMESTAMP '2013-05-11 02:17:37'
/
-- new object type path: SCHEMA_EXPORT/TYPE/TYPE_BODY
-- CONNECT SYS
CREATE TYPE BODY "PLF_PROD"."PLF_STRING_AGG_TYPE" IS

  STATIC FUNCTION ODCIAggregateInitialize(sctx IN OUT plf_string_agg_type)
    RETURN NUMBER IS
  BEGIN
    sctx := plf_string_agg_type(NULL);
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateIterate(SELF  IN OUT plf_string_agg_type,
                                       VALUE IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    SELF.total := SELF.total || ',' || VALUE;
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateTerminate(SELF        IN plf_string_agg_type,
                                         returnValue OUT CLOB,
                                         flags       IN NUMBER) RETURN NUMBER IS
  BEGIN
    returnValue := ltrim(SELF.total, ',');
    RETURN ODCIConst.Success;
  END;

  MEMBER FUNCTION ODCIAggregateMerge(SELF IN OUT plf_string_agg_type,
                                     ctx2 IN plf_string_agg_type) RETURN NUMBER IS
  BEGIN
    SELF.total := SELF.total || ctx2.total;
    RETURN ODCIConst.Success;
  END;

END;
/

ALTER TYPE "PLF_PROD"."PLF_STRING_AGG_TYPE" 
  COMPILE BODY 
    PLSQL_OPTIMIZE_LEVEL=  2
    PLSQL_CODE_TYPE=  INTERPRETED
    PLSQL_DEBUG=  TRUE    PLSCOPE_SETTINGS=  'IDENTIFIERS:NONE'

/
-- new object type path: SCHEMA_EXPORT/TABLE/CONSTRAINT/REF_CONSTRAINT
ALTER TABLE "PLF_PROD"."ERRLOG" ADD CONSTRAINT "ERRLOG_FK1" FOREIGN KEY ("APPLICATION_ID")
	  REFERENCES "PLF_PROD"."APPLICATIONS" ("APPLICATION_ID") ENABLE;
ALTER TABLE "PLF_PROD"."ERROR_MESSAGES" ADD CONSTRAINT "ERROR_MESSAGES_FK1" FOREIGN KEY ("APPLICATION_ID")
	  REFERENCES "PLF_PROD"."APPLICATIONS" ("APPLICATION_ID") ENABLE;
-- new object type path: SCHEMA_EXPORT/TABLE/STATISTICS/TABLE_STATISTICS
DECLARE 
  c varchar2(60); 
  nv varchar2(1); 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
  s varchar2(60) := 'PLF_PROD'; 
  t varchar2(60) := 'ERRLOG'; 
  p varchar2(1); 
  sp varchar2(1); 
  stmt varchar2(300) := 'INSERT INTO "SYS"."IMPDP_STATS" (type,version,c1,c2,c3,c4,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,d1,r1,r2,ch1,flags,cl1) VALUES (:1,6,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n9,n10,n11,n12,d1) VALUES ('T',6,2,t,p,sp,s,
               26663,1003,142,2000,0,NULL,NULL,NULL,
               TO_DATE('2008-07-09 22:14:35',df));
  c := 'ERROR_ID'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               26663,.0000375051569590819,0,nv,0,1,30267,5,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'C102','C3040344',nv,2,nv;
  c := 'APPLICATION_ID'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,1,0,nv,436,1,1,3,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'C102','C102',nv,2,nv;
  c := 'ERROR_TIME'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               26663,.0000375051569590819,0,nv,0,2454173.55006562,2454644.90190724,11,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'786B030D0E0D0627E71A68','786C061A16272D2ECE73D0',nv,2,nv;
  c := 'ERROR_CODE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               18,.0555555555555556,0,nv,0,2.34647196704646E+35,3.85575182502907E+35,4,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'2D31','4A4253',nv,2,nv;

END; 
/

DECLARE 
  c varchar2(60); 
  nv varchar2(1); 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
  s varchar2(60) := 'PLF_PROD'; 
  t varchar2(60) := 'ERRLOG'; 
  p varchar2(1); 
  sp varchar2(1); 
  stmt varchar2(300) := 'INSERT INTO "SYS"."IMPDP_STATS" (type,version,c1,c2,c3,c4,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,d1,r1,r2,ch1,flags,cl1) VALUES (:1,6,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23)';
BEGIN
  NULL; 
  c := 'ERROR_MESSAGE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               51,.0196078431372549,0,nv,0,2.60673568862420E+35,4.11859773231023E+35,32,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'323433','4F52412D33303637383A20746F6F206D616E79206F70656E20636F6E6E656374',nv,2,nv;
  c := 'STACK_TRACE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               0,0,0,nv,0,0,0,87,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),nv,nv,nv,2,nv;
  c := 'MODULE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,1,0,nv,26285,5.05689704737415E+35,5.05689704737415E+35,2,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'61646D696E746F6F6C','61646D696E746F6F6C',nv,2,nv;
  c := 'SESSION_ID'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               182,.00549450549450549,0,nv,26285,2.50229331258563E+35,3.64884921252824E+35,2,0,nv,nv,
               TO_DATE('2008-07-09 22:14:35',df),'3031423035313639303933363235464542363736463732423037413137334136','4646373041463036314533463233464144453734464232333839444236373446',nv,2,nv;

  DBMS_STATS.IMPORT_TABLE_STATS('"PLF_PROD"','"ERRLOG"',NULL,'"IMPDP_STATS"',NULL,NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/

DECLARE 
  c varchar2(60); 
  nv varchar2(1); 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
  s varchar2(60) := 'PLF_PROD'; 
  t varchar2(60) := 'ERROR_MESSAGES'; 
  p varchar2(1); 
  sp varchar2(1); 
  stmt varchar2(300) := 'INSERT INTO "SYS"."IMPDP_STATS" (type,version,c1,c2,c3,c4,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,d1,r1,r2,ch1,flags,cl1) VALUES (:1,6,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n9,n10,n11,n12,d1) VALUES ('T',6,2,t,p,sp,s,
               32,8,144,2000,0,NULL,NULL,NULL,
               TO_DATE('2008-07-09 22:14:30',df));
  c := 'ERROR_CODE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               32,.03125,0,nv,0,1050,1084,4,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'C20B33','C20B55',nv,2,nv;
  c := 'APPLICATION_ID'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,.015625,0,nv,0,1,1,3,1,32,1,
               TO_DATE('2008-07-09 22:14:30',df),'C102','C102',nv,2,nv;
  c := 'CONDITION_NAME'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               32,.03125,0,nv,0,3.49349710583125E+35,4.43034165208732E+35,24,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'434845434B5F434F4E53545241494E545F56494F4C4154494F4E','555345525F47524F55505F4E4F545F53414D455F435553544F4D4552',nv,2,nv;
  c := 'USER_MESSAGE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               32,.03125,0,nv,0,3.38156285889073E+35,4.64375072891056E+35,80,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'4120646174616261736520636865636B20636F6E73747261696E742076696F6C','596F7572206163636F756E74206973206C6F636B6564212020506C6561736520',nv,2,nv;

END; 
/

DECLARE 
  c varchar2(60); 
  nv varchar2(1); 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
  s varchar2(60) := 'PLF_PROD'; 
  t varchar2(60) := 'ERROR_MESSAGES'; 
  p varchar2(1); 
  sp varchar2(1); 
  stmt varchar2(300) := 'INSERT INTO "SYS"."IMPDP_STATS" (type,version,c1,c2,c3,c4,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,d1,r1,r2,ch1,flags,cl1) VALUES (:1,6,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23)';
BEGIN
  NULL; 
  c := 'HELP_TEXT'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               12,.0833333333333333,0,nv,0,3.39840916768838E+35,6.30528547080715E+35,15,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'41737369676E207468652067726F757020746F207468652064617368626F6172','796F75206E6565642068656C70',nv,2,nv;
  c := 'CREATED_BY'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               3,.333333333333333,0,nv,0,5.11266735089655E+35,5.52725169073141E+35,12,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'6277656E65727374726F6D','6A73746F77656C6C',nv,2,nv;
  c := 'CREATE_DATE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               5,.2,0,nv,0,2454162,2454399,8,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'786B0302010101','786B0A19010101',nv,2,nv;

  DBMS_STATS.IMPORT_TABLE_STATS('"PLF_PROD"','"ERROR_MESSAGES"',NULL,'"IMPDP_STATS"',NULL,NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/

DECLARE 
  c varchar2(60); 
  nv varchar2(1); 
  df varchar2(21) := 'YYYY-MM-DD:HH24:MI:SS'; 
  s varchar2(60) := 'PLF_PROD'; 
  t varchar2(60) := 'APPLICATIONS'; 
  p varchar2(1); 
  sp varchar2(1); 
  stmt varchar2(300) := 'INSERT INTO "SYS"."IMPDP_STATS" (type,version,c1,c2,c3,c4,c5,n1,n2,n3,n4,n5,n6,n7,n8,n9,n10,n11,d1,r1,r2,ch1,flags,cl1) VALUES (:1,6,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12,:13,:14,:15,:16,:17,:18,:19,:20,:21,:22,:23)';
BEGIN
  DELETE FROM "SYS"."IMPDP_STATS"; 
  INSERT INTO "SYS"."IMPDP_STATS" (type,version,flags,c1,c2,c3,c5,n1,n2,n3,n4,n9,n10,n11,n12,d1) VALUES ('T',6,2,t,p,sp,s,
               1,4,16,2000,0,NULL,NULL,NULL,
               TO_DATE('2008-07-09 22:14:30',df));
  c := 'APPLICATION_ID'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,1,0,nv,0,1,1,3,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'C102','C102',nv,2,nv;
  c := 'APPLICATION_NAME'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,1,0,nv,0,4.33077730406033E+35,4.33077730406033E+35,10,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'536861727056696577','536861727056696577',nv,2,nv;
  c := 'APP_CODE'; 
  EXECUTE IMMEDIATE stmt USING 'C',t,p,sp,c,s,
               1,1,0,nv,0,4.32704926484305E+35,4.32704926484305E+35,3,0,nv,nv,
               TO_DATE('2008-07-09 22:14:30',df),'5356','5356',nv,2,nv;

  DBMS_STATS.IMPORT_TABLE_STATS('"PLF_PROD"','"APPLICATIONS"',NULL,'"IMPDP_STATS"',NULL,NULL,'"SYS"'); 
  DELETE FROM "SYS"."IMPDP_STATS"; 
END; 
/

