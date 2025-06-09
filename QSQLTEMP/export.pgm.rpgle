     h dftactgrp(*no) actgrp(*caller) bnddir('TSUTILSRV') option(*nodebugio)
      *
1082  * 12-19-20 Stand alone for Cambell County. Rename file to first index +
      *          hyphen + 4 digit seq# + .TIF. I.E. 17123430-0001.TIF.
      *
1081  * 08-22-20 Change report csv format to contain most of the attributes
      *          from MRPTDIR.
      *          Bring back code from this program that allows export of text
      *          reports because MAG2038 does not export page breaks. This may
      *          have an impact on performance.
      *
      * 04-09-20 Allow offline reports to export.
      *
      * 04-03-20 Allow export without indexes. rptIndxFmt = 'A' vs 'I'.
      *
      * 03-11-19 PDF bug. MAG210 dtaq was being updated with previous exported
      *          record that caused the same previous PDF to be output for the
      *          current PDF being processed.
      * 02-08-19 Extra string delimiter in output string to the CSV was causing
      *          half the expected records in the CSV. Probably can be
      *          attributed to OnBase mods again.
      * 01-10-19 OnBase modification 1073 caused csv header not to be created.
      * 01-09-19 Compensate for report spool file names (mrptdir.filnam)
      *          starting with a digit. MAG2038 handles changing '-' and
      *          and the cent sign into '#' character.
      * 11-18-18 Allow single PDF document export with many docLinks scenario.
      *          Taking too long to extract pages from large documents. Utilizes
      *          the Export as (R)eport must be used in the config.
      * 10-25-18 Add OnBase keywords. If OnBase doc type specified in config,
      *          prepend the type to the csv output, format the document type
      *          to the CSV record, convert the document suffix to the onBase
      *          required values: PDF=16, XLS=12, TXT=1, etc.
      * 06-27-18 Add seqnum to exception join between log and index table for
      *          reports.
      *          Retry open operation of CSV file FOREVER due to possible
      *          target resource activity.
      * 03-12-18 Handle conversion of PCL to PDF.
      * 02-06-18 Add parm for converting to PDF.
      * 02-01-18 Inverse of previous fix...allow entire PDF doc to be output
      *          and reference by however many link records.
      * 01-27-18 Native PDFs will now output pages by specified by the link
      *          page range.
      * 01-20-18 Add switch to output only file name in CSV...no path.
      * 12-18-17 Export native PDF documents.
      * 06-06-17 Added the print file to allow specification of page rotation
      *          in instances where PDF files are not in the correct orientation
      *          Create a print file, set the PAGRTT to the desired rotate value
      *          and enter that print file name in the document type print file
      *          parms. *AUTO appears to work in most instances where the
      *          the spool file is archived with a different rotation value.
      * 05-31-17 In conjunction with last change to convert reports to PDF,
      *          use the report description as the file name if one exists
      *          otherwise, default to the report ID (spy#).
      * 05-24-17 Add conversion to PDF option. Requires v7r1 or higher using
      *          the CPYSPLF *TOSTMF option. Reports only.
      * 09-24-14 Print using MAG2038 with original file name instead of
      *          *ORIG to avoid original documents printing with alternate
      *          report keys.
      * 02-28-14 Add starting and ending page to the link csv.
      * 02-27-14 Fix CRLF missing from anno csv header record.
      *          Reenable whole report output.
      * 02-27-14 Remove mopttbl1 override and dltovr.
      * 02-19-14 Make sure the anno seq# is not zero by checking if the page#
      *          for the anno is between in the query against the link instead
      *          of >= and <=.
      * 01-15-14 Note CSV header not acknowledging field separator.
      *          Annotation seq# is image start page instead of image seq#.
      * 12-20-13 Index CSV for reports outputs only the file name instead of
      *          acknowledging the nameOnly setting in the cfg dtaara.
      * 12-19-13 Note CSV header got stepped on in previous mods.
      * 12-10-13 Annotations are not output for doclinks with page
      *          ranges and EXPORTCMD2 does not output link headers in the link
      *          csv. Added new procedure getLnkDef() to retrieve the lnkdef
      *          after reading first input csv record.
      * 12-10-13 Page range not acknowledged for report doclinks causing
      *          it to look like only the last page being printed.
      * 12-10-13 Various fixes needed for report notes csv. Changed the
      *          note selection process to be same as images. Modification in
      *          1040 made it apparent this had to be done.
      * 12-07-13 Correct non-export of reports using EXPORTCMD2.
      * 12-02-13 Compensate for STMFCCSID parm on CPYTOIMPF not supported
      *          under v5r4 or less. Fixed unquoted comma for field separator.
      * 11-23-13 Fix index wildcard selection for images.
      * 11-08-13 Add sequence number to export log.
      *          Add new command to provide export by IFS CSV file.
      * 10-16-13 Add Batch and Seq columns to old format header.
      *          Allow output of reports without links.
      * 10-08-13 Make sure all CSV field delimiters are quoted.
      *          Backups are marked 34x & 35x because there was an issue with
      *          RDP losing connection and writing source to a different
      *          and causing all sorts of problems. So...watch out.
      * 10-06-13 Add annotation filter types.
      * 10-05-13 Inline annotations, add index search criteria to exportcmd,
      *          include wildcard capability to index search criteria with
      *          leading and trailing wildcard support. % is the wildcard.
      * 10-05-13 Fix oldcsv formatting.
      * 09-25-13 Fix alternate create date CYYMMDD formatting for 'new' csv form
      * 08-03-13 Allow for CYYMMDD create date format. Also add $CRTDT in blank
      *          field previous to create date in CSV.
      * 07-16-13 Exporting reports to IFS had some issues. Was processing and
      *          cleaning up CSV as if duplicates existed for image processing.
      *          Decimal data error, too, when trying to write to CSV as report
      *          to IFS vs as index.
      * 06-28-13 Add build ID to interface. Starting with 1027. Also fix ovrdbf
      *          to MOPTTBL. Uses the library in MRPTDIR for the override
      *          library causing a hard error if the folder is located in
      *          SPYFOLDERS or other library.

     fexpcfg    if   e             disk

      *copy tsutilsrvh
     d link_t          ds                  qualified
     d  id                           10
     d  seq                           9p 0
     d  spg                           9p 0
     d  epg                           9p 0
     d  ndx1                         99
     d  ndx2                         99
     d  ndx3                         99
     d  ndx4                         99
     d  ndx5                         99
     d  ndx6                         99
     d  ndx7                         99
     d  date                          8

     d OK              c                   0
     d KEYNOMATCH      c                   -1
     d LOCK_CHECK      c                   1
     d LOCK_LOCK       c                   2
     d LOCK_UNLOCK     c                   3
     d OBJTYPIMG       c                   'I'
     d OBJTYPRPT       c                   'R'
     d OBJTYPERR       c                   ' '
     d OBJTYPALL       c                   'A'
     d FOLDEROK        c                   0
     d FOLDERNF        c                   -1

     d validateKey     pr            10i 0
     d  keyInput                     16    const
     d  expiry                        8    const
     d  notes                         1    const

     d rtvsysval       pr            10
     d  sysval                       10    value

     d chkobj          pr
     d  object                       10    const
     d  library                      10    const
     d  type                         10    const
     d  rtnSts                       10i 0

     d lockExport      pr            10i 0
     d  operaton                     10i 0 const

     d getObjTyp       pr             1
     d  docType                      10    const

     d writeLog        pr
     d  folder                       10    const
     d  class                        10    const
     d  objectID                     10    const
     d  seq                          10i 0 const
     d  objectDate                    8p 0 const
     d  message                      80    const
     d  link                               likeds(link_t) const options(*nopass)

     d chkFolder       pr            10i 0
     d  folder                       10    const

      *copy ifsio_h
     /*-
      * Copyright (c) 2002-2006 Scott C. Klement
      * All rights reserved.
      *
      * Redistribution and use in source and binary forms, with or without
      * modification, are permitted provided that the following conditions
      * are met:
      * 1. Redistributions of source code must retain the above copyright
      *    notice, this list of conditions and the following disclaimer.
      * 2. Redistributions in binary form must reproduce the above copyright
      *    notice, this list of conditions and the following disclaimer in the
      *    documentation and/or other materials provided with the distribution.
      *
      * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
      * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
      * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPO
      * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
      * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTI
      * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
      * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
      * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRI
      * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WA
      * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
      * SUCH DAMAGE.
      *
      */
     D/if defined(IFSIO_H)
     D/eof
     D/endif

     D/define IFSIO_H

      **********************************************************************
      * Some CCSID definitions that I've found useful
      **********************************************************************
     D CP_MSDOS        C                   437
     D CP_ISO8859_1    C                   819
     D CP_WINDOWS      C                   1252
     D CP_UTF8         C                   1208
     D CP_UCS2         C                   1200
     D CP_CURJOB       C                   0

      **********************************************************************
      *  Flags for use in open()
      *
      * More than one can be used -- add them together.
      **********************************************************************
      *  00000000000000000000000000000001          Reading Only
     D O_RDONLY        C                   1
      *  00000000000000000000000000000010          Writing Only
     D O_WRONLY        C                   2
      *  00000000000000000000000000000100          Reading & Writing
     D O_RDWR          C                   4
      *  00000000000000000000000000001000          Create File if needed
     D O_CREAT         C                   8
      *  00000000000000000000000000010000          Exclusively create --
      *                                              open will fail if it
      *                                              already exists.
     D O_EXCL          C                   16
      *  00000000000000000000000000100000          Assign a CCSID to new
      *                                            file.
     D O_CCSID         C                   32
      *  00000000000000000000000001000000          Truncate file to 0 bytes
     D O_TRUNC         C                   64
      *  00000000000000000000000100000000          Append to file
      *                                            (write data at end only)
     D O_APPEND        C                   256
      *  00000000000000000000010000000000          Synchronous write
     D O_SYNC          C                   1024
      *  00000000000000000000100000000000          Sync write, data only
     D O_DSYNC         C                   2048
      *  00000000000000000001000000000000          Sync read
     D O_RSYNC         C                   4096
      *  00000000000000001000000000000000          No controlling terminal
     D O_NOCTTY        C                   32768
      *  00000000000000010000000000000000          Share with readers only
     D O_SHARE_RDONLY  C                   65536
      *  00000000000000100000000000000000          Share with writers only
     D O_SHARE_WRONLY  C                   131072
      *  00000000000001000000000000000000          Share with read & write
     D O_SHARE_RDWR    C                   262144
      *  00000000000010000000000000000000          Share with nobody.
     D O_SHARE_NONE    C                   524288
      *  00000000100000000000000000000000          Assign a code page
     D O_CODEPAGE      C                   8388608
      *  00000001000000000000000000000000          Open in text-mode
     D O_TEXTDATA      C                   16777216
      *  00000010000000000000000000000000          Allow text translation
      *                                            on newly created file.
      * Note: O_TEXT_CREAT requires all of the following flags to work:
      *           O_CREAT+O_TEXTDATA+(O_CODEPAGE or O_CCSID)
     D O_TEXT_CREAT    C                   33554432
      *  00001000000000000000000000000000          Inherit mode from dir
     D O_INHERITMODE   C                   134217728
      *  00100000000000000000000000000000          Large file access
      *                                            (for >2GB files)
     D O_LARGEFILE     C                   536870912

      **********************************************************************
      * Access mode flags for access() and accessx()
      *
      *   F_OK = File Exists
      *   R_OK = Read Access
      *   W_OK = Write Access
      *   X_OK = Execute or Search
      **********************************************************************
     D F_OK            C                   0
     D R_OK            C                   4
     D W_OK            C                   2
     D X_OK            C                   1

      **********************************************************************
      * class of users flags for accessx()
      *
      *   ACC_SELF = Check access based on effective uid/gid
      *   ACC_INVOKER = Check access based on real uid/gid
      *                 ( this is equvalent to calling access() )
      *   ACC_OTHERS = Check access of someone not the owner
      *   ACC_ALL = Check access of all users
      **********************************************************************
     D ACC_SELF        C                   0
     D ACC_INVOKER     C                   1
     D ACC_OTHERS      C                   8
     D ACC_ALL         C                   32

      **********************************************************************
      *      Mode Flags.
      *         basically, the mode parm of open(), creat(), chmod(),etc
      *         uses 9 least significant bits to determine the
      *         file's mode. (peoples access rights to the file)
      *
      *           user:       owner    group    other
      *           access:     R W X    R W X    R W X
      *           bit:        8 7 6    5 4 3    2 1 0
      *
      * (This is accomplished by adding the flags below to get the mode)
      **********************************************************************
      *                                         owner authority
     D S_IRUSR         C                   256
     D S_IWUSR         C                   128
     D S_IXUSR         C                   64
     D S_IRWXU         C                   448
      *                                         group authority
     D S_IRGRP         C                   32
     D S_IWGRP         C                   16
     D S_IXGRP         C                   8
     D S_IRWXG         C                   56
      *                                         other people
     D S_IROTH         C                   4
     D S_IWOTH         C                   2
     D S_IXOTH         C                   1
     D S_IRWXO         C                   7
      *                                         special modes:
      *                                         Set effective GID
     D S_ISGID         C                   1024
      *                                         Set effective UID
     D S_ISUID         C                   2048

      **********************************************************************
      * My own special MODE shortcuts for open() (instead of those above)
      **********************************************************************
     D M_RDONLY        C                   const(292)
     D M_RDWR          C                   const(438)
     D M_RWX           C                   const(511)

      **********************************************************************
      * "whence" constants for use with seek(), lseek() and others
      **********************************************************************
      /if not defined(SEEK_WHENCE_VALUES)
     D SEEK_SET        C                   CONST(0)
     D SEEK_CUR        C                   CONST(1)
     D SEEK_END        C                   CONST(2)
      /define SEEK_WHENCE_VALUES
      /endif

      **********************************************************************
      * flags specified in the f_flags element of the ds_statvfs
      *   data structure used by the statvfs() API
      **********************************************************************
     D ST_RDONLY...
     D                 C                   CONST(1)
     D ST_NOSUID...
     D                 C                   CONST(2)
     D ST_CASE_SENSITITIVE...
     D                 C                   CONST(4)
     D ST_CHOWN_RESTRICTED...
     D                 C                   CONST(8)
     D ST_THREAD_SAFE...
     D                 C                   CONST(16)
     D ST_DYNAMIC_MOUNT...
     D                 C                   CONST(32)
     D ST_NO_MOUNT_OVER...
     D                 C                   CONST(64)
     D ST_NO_EXPORTS...
     D                 C                   CONST(128)
     D ST_SYNCHRONOUS...
     D                 C                   CONST(256)

      **********************************************************************
      * Constants used by pathconf() API
      **********************************************************************
     D PC_CHOWN_RESTRICTED...
     D                 C                   0
     D PC_LINK_MAX...
     D                 C                   1
     D PC_MAX_CANON...
     D                 C                   2
     D PC_MAX_INPUT...
     D                 C                   3
     D PC_NAME_MAX...
     D                 C                   4
     D PC_NO_TRUNC...
     D                 C                   5
     D PC_PATH_MAX...
     D                 C                   6
     D PC_PIPE_BUF...
     D                 C                   7
     D PC_VDISABLE...
     D                 C                   8
     D PC_THREAD_SAFE...
     D                 C                   9

      **********************************************************************
      * Constants used by sysconf() API
      **********************************************************************
     D SC_CLK_TCK...
     D                 C                   2
     D SC_NGROUPS_MAX...
     D                 C                   3
     D SC_OPEN_MAX...
     D                 C                   4
     D SC_STREAM_MAX...
     D                 C                   5
     D SC_CCSID...
     D                 C                   10
     D SC_PAGE_SIZE...
     D                 C                   11
     D SC_PAGESIZE...
     D                 C                   12

      **********************************************************************
      * File Information Structure (stat)
      *   struct stat {
      *     mode_t         st_mode;       /* File mode                       */
      *     ino_t          st_ino;        /* File serial number              */
      *     nlink_t        st_nlink;      /* Number of links                 */
      *     unsigned short st_reserved2;  /* Reserved                    @B4A*/
      *     uid_t          st_uid;        /* User ID of the owner of file    */
      *     gid_t          st_gid;        /* Group ID of the group of file   */
      *     off_t          st_size;       /* For regular files, the file
      *                                      size in bytes                   */
      *     time_t         st_atime;      /* Time of last access             */
      *     time_t         st_mtime;      /* Time of last data modification  */
      *     time_t         st_ctime;      /* Time of last file status change */
      *     dev_t          st_dev;        /* ID of device containing file    */
      *     size_t         st_blksize;    /* Size of a block of the file     */
      *     unsigned long  st_allocsize;  /* Allocation size of the file     */
      *     qp0l_objtype_t st_objtype;    /* AS/400 object type              */
      *     char           st_reserved3;  /* Reserved                    @B4A*/
      *     unsigned short st_codepage;   /* Object data codepage            */
      *     unsigned short st_ccsid;      /* Object data ccsid           @AAA*/
      *     dev_t          st_rdev;       /* Device ID (if character special */
      *                                   /* or block special file)      @B4A*/
      *     nlink32_t      st_nlink32;    /* Number of links-32 bit      @B5C*/
      *     dev64_t        st_rdev64;     /* Device ID - 64 bit form     @B4A*/
      *     dev64_t        st_dev64;      /* ID of device containing file -  */
      *                                   /* 64 bit form.                @B4A*/
      *     char           st_reserved1[36]; /* Reserved                 @B4A*/
      *     unsigned int   st_ino_gen_id; /* File serial number generation id
      *  };
      *                                                                  @A2A*/
      **********************************************************************
     D statds          DS                  qualified
     D                                     BASED(Template)
     D  st_mode                      10U 0
     D  st_ino                       10U 0
     D  st_nlink                      5U 0
     D  st_reserved2                  5U 0
     D  st_uid                       10U 0
     D  st_gid                       10U 0
     D  st_size                      10I 0
     D  st_atime                     10I 0
     D  st_mtime                     10I 0
     D  st_ctime                     10I 0
     D  st_dev                       10U 0
     D  st_blksize                   10U 0
     D  st_allocsize                 10U 0
     D  st_objtype                   11A
     D  st_reserved3                  1A
     D  st_codepage                   5U 0
     D  st_ccsid                      5U 0
     D  st_rdev                      10U 0
     D  st_nlink32                   10U 0
     D  st_rdev64                    20U 0
     D  st_dev64                     20U 0
     D  st_reserved1                 36A
     D  st_ino_gen_id                10U 0


      **********************************************************************
      * File Information Structure, Large File Enabled (stat64)
      *   struct stat64 {                                                    */
      *     mode_t         st_mode;       /* File mode                       */
      *     ino_t          st_ino;        /* File serial number              */
      *     uid_t          st_uid;        /* User ID of the owner of file    */
      *     gid_t          st_gid;        /* Group ID of the group of fileA2A*/
      *     off64_t        st_size;       /* For regular files, the file     */
      *                                      size in bytes                   */
      *     time_t         st_atime;      /* Time of last access             */
      *     time_t         st_mtime;      /* Time of last data modification2A*/
      *     time_t         st_ctime;      /* Time of last file status changeA*/
      *     dev_t          st_dev;        /* ID of device containing file    */
      *     size_t         st_blksize;    /* Size of a block of the file     */
      *     nlink_t        st_nlink;      /* Number of links                 */
      *     unsigned short st_codepage;   /* Object data codepage            */
      *     unsigned long long st_allocsize; /* Allocation size of the file2A*/
      *     unsigned int   st_ino_gen_id; /* File serial number generationAid*/
      *                                                                      */
      *     qp0l_objtype_t st_objtype;    /* AS/400 object type              */
      *     char           st_reserved2[5]; /* Reserved                  @B4A*/
      *     dev_t          st_rdev;       /* Device ID (if character specialA*/
      *                                   /* or block special file)      @B4A*/
      *     dev64_t        st_rdev64;     /* Device ID - 64 bit form     @B4A*/
      *     dev64_t        st_dev64;      /* ID of device containing file@-2A*/
      *                                   /* 64 bit form.                @B4A*/
      *     nlink32_t      st_nlink32;    /* Number of links-32 bit      @B5A*/
      *     char           st_reserved1[26]; /* Reserved            @B4A @B5C*/
      *     unsigned short st_ccsid;      /* Object data ccsid           @AAA*/
      *  };                                                                  */
      *
      **********************************************************************
     D statds64        DS                  qualified
     D                                     BASED(Template)
     D  st_mode                      10U 0
     D  st_ino                       10U 0
     D  st_uid                       10U 0
     D  st_gid                       10U 0
     D  st_size                      20I 0
     D  st_atime                     10I 0
     D  st_mtime                     10I 0
     D  st_ctime                     10I 0
     D  st_dev                       10U 0
     D  st_blksize                   10U 0
     D  st_nlink                      5U 0
     D  st_codepage                   5U 0
     D  st_allocsize                 20U 0
     D  st_ino_gen_id                10U 0
     D  st_objtype                   11A
     D  st_reserved2                  5A
     D  st_rdev                      10U 0
     D  st_rdev64                    20U 0
     D  st_dev64                     20U 0
     D  st_nlink32                   10U 0
     D  st_reserved1                 26A
     D  st_ccsid                      5U 0

      **********************************************************************
      * ds_statvfs - data structure to receive file system info
      *
      *   f_bsize   = file system block size (in bytes)
      *   f_frsize  = fundamental block size in bytes.
      *                if this is zero, f_blocks, f_bfree and f_bavail
      *                are undefined.
      *   f_blocks  = total number of blocks (in f_frsize)
      *   f_bfree   = total free blocks in filesystem (in f_frsize)
      *   f_bavail  = total blocks available to users (in f_frsize)
      *   f_files   = total number of file serial numbers
      *   f_ffree   = total number of unused file serial numbers
      *   f_favail  = number of available file serial numbers to users
      *   f_fsid    = filesystem ID.  This will be 4294967295 if it's
      *                too large for a 10U 0 field. (see f_fsid64)
      *   f_flag    = file system flags (see below)
      *   f_namemax = max filename length.  May be 4294967295 to
      *                indicate that there is no maximum.
      *   f_pathmax = max pathname legnth.  May be 4294967295 to
      *                indicate that there is no maximum.
      *   f_objlinkmax = maximum number of hard-links for objects
      *                other than directories
      *   f_dirlinkmax = maximum number of hard-links for directories
      *   f_fsid64  = filesystem id (in a 64-bit integer)
      *   f_basetype = null-terminated string containing the file
      *                  system type name.  For example, this might
      *                  be "root" or "Network File System (NFS)"
      *
      *  Since f_basetype is null-terminated, you should read it
      *  in ILE RPG with:
      *       myString = %str(%addr(ds_statvfs.f_basetype))
      **********************************************************************
     D ds_statvfs      DS                  qualified
     D                                     BASED(Template)
     D  f_bsize                      10U 0
     D  f_frsize                     10U 0
     D  f_blocks                     20U 0
     D  f_bfree                      20U 0
     D  f_bavail                     20U 0
     D  f_files                      10U 0
     D  f_ffree                      10U 0
     D  f_favail                     10U 0
     D  f_fsid                       10U 0
     D  f_flag                       10U 0
     D  f_namemax                    10U 0
     D  f_pathmax                    10U 0
     D  f_objlinkmax                 10I 0
     D  f_dirlinkmax                 10I 0
     D  f_reserved1                   4A
     D  f_fsid64                     20U 0
     D  f_basetype                   80A


      **********************************************************************
      * Group Information Structure (group)
      *
      *  struct group {
      *        char    *gr_name;        /* Group name.                      */
      *        gid_t   gr_gid;          /* Group id.                        */
      *        char    **gr_mem;        /* A null-terminated list of pointers
      *                                    to the individual member names.  */
      *  };
      *
      **********************************************************************
     D group           DS                  qualified
     D                                     BASED(Template)
     D   gr_name                       *
     D   gr_gid                      10U 0
     D   gr_mem                        *   DIM(256)


      **********************************************************************
      * User Information Structure (passwd)
      *
      * (Don't let the name fool you, this structure does not contain
      *  any password information.  Its named after the UNIX file that
      *  contains all of the user info.  That file is "passwd")
      *
      *   struct passwd {
      *        char    *pw_name;            /* User name.                   */
      *        uid_t   pw_uid;              /* User ID number.              */
      *        gid_t   pw_gid;              /* Group ID number.             */
      *        char    *pw_dir;             /* Initial working directory.   */
      *        char    *pw_shell;           /* Initial user program.        */
      *   };
      *
      **********************************************************************
     D passwd          DS                  qualified
     D                                     BASED(Template)
     D  pw_name                        *
     D  pw_uid                       10U 0
     D  pw_gid                       10U 0
     D  pw_dir                         *
     D  pw_shell                       *


      **********************************************************************
      * File Time Structure (utimbuf)
      *
      * struct utimbuf {
      *    time_t     actime;           /*  access time       */
      *    time_t     modtime;          /*  modification time */
      * };
      *
      **********************************************************************
     D utimbuf         DS                  qualified
     D                                     BASED(Template)
     D   actime                      10I 0
     D   modtime                     10I 0


      **********************************************************************
      * Directory Entry Structure (dirent)
      *
      * struct dirent {
      *   char           d_reserved1[16];  /* Reserved                       */
      *   unsigned int   d_fileno_gen_id   /* File number generation ID  @A1C*/
      *   ino_t          d_fileno;         /* The file number of the file    */
      *   unsigned int   d_reclen;         /* Length of this directory entry
      *                                     * in bytes                       */
      *   int            d_reserved3;      /* Reserved                       */
      *   char           d_reserved4[8];   /* Reserved                       */
      *   qlg_nls_t      d_nlsinfo;        /* National Language Information
      *                                     * about d_name                   */
      *   unsigned int   d_namelen;        /* Length of the name, in bytes
      *                                     * excluding NULL terminator      */
      *   char           d_name[_QP0L_DIR_NAME]; /* Name...null terminated   */
      *
      * };
      **********************************************************************
     D dirent          ds                  qualified
     D                                     BASED(Template)
     D   d_reserv1                   16A
     D   d_fileno_gen_id...
     D                               10U 0
     D   d_fileno                    10U 0
     D   d_reclen                    10U 0
     D   d_reserv3                   10I 0
     D   d_reserv4                    8A
     D   d_nlsinfo                   12A
     D    d_nls_ccsid                10I 0 OVERLAY(d_nlsinfo:1)
     D    d_nls_cntry                 2A   OVERLAY(d_nlsinfo:5)
     D    d_nls_lang                  3A   OVERLAY(d_nlsinfo:7)
     D   d_namelen                   10U 0
     D   d_name                     640A

      **********************************************************************
      * I/O Vector Structure
      *
      *     struct iovec {
      *        void    *iov_base;
      *        size_t  iov_len;
      *     }
      **********************************************************************
     D iovec           DS                  qualified
     D                                     BASED(Template)
     D  iov_base                       *
     D  iov_len                      10U 0

      *--------------------------------------------------------------------
      * Determine file accessibility
      *
      * int access(const char *path, int amode)
      *
      *--------------------------------------------------------------------
     D access          PR            10I 0 ExtProc('access')
     D   Path                          *   Value Options(*string)
     D   amode                       10I 0 Value


      *--------------------------------------------------------------------
      * Determine file accessibility for a class of users
      *
      * int accessx(const char *path, int amode, int who);
      *
      *--------------------------------------------------------------------
     D accessx         PR            10I 0 ExtProc('accessx')
     D   Path                          *   Value Options(*string)
     D   amode                       10I 0 Value
     D   who                         10I 0 value

      *--------------------------------------------------------------------
      * Change Directory
      *
      * int chdir(const char *path)
      *--------------------------------------------------------------------
     D chdir           PR            10I 0 ExtProc('chdir')
     D   path                          *   Value Options(*string)

      *--------------------------------------------------------------------
      * Change file authorizations
      *
      * int chmod(const char *path, mode_t mode)
      *--------------------------------------------------------------------
     D chmod           PR            10I 0 ExtProc('chmod')
     D   path                          *   Value options(*string)
     D   mode                        10U 0 Value

      *--------------------------------------------------------------------
      * Change Owner/Group of File
      *
      * int chown(const char *path, uid_t owner, gid_t group)
      *--------------------------------------------------------------------
     D chown           PR            10I 0 ExtProc('chown')
     D   path                          *   Value options(*string)
     D   owner                       10U 0 Value
     D   group                       10U 0 Value

      *--------------------------------------------------------------------
      * Close a file
      *
      * int close(int fildes)
      *
      * Note:  Because the same close() API is used for IFS, sockets,
      *        and pipes, it's conditionally defined here.  If it's
      *        done the same in the sockets & pipe /copy members,
      *        there will be no conflict.
      *--------------------------------------------------------------------
     D/if not defined(CLOSE_PROTOTYPE)
     D close           PR            10I 0 ExtProc('close')
     D  fildes                       10I 0 value
     D/define CLOSE_PROTOTYPE
     D/endif

      *--------------------------------------------------------------------
      * Close a directory
      *
      * int closedir(DIR *dirp)
      *--------------------------------------------------------------------
     D closedir        PR            10I 0 EXTPROC('closedir')
     D  dirp                           *   VALUE

      *--------------------------------------------------------------------
      * Create or Rewrite File
      *
      * int creat(const char *path, mode_t mode)
      *
      * DEPRECATED:  Use open() instead.
      *--------------------------------------------------------------------
     D creat           PR            10I 0 ExtProc('creat')
     D   path                          *   Value options(*string)
     D   mode                        10U 0 Value

      *--------------------------------------------------------------------
      * Duplicate open file descriptor
      *
      * int dup(int fildes)
      *--------------------------------------------------------------------
     D dup             PR            10I 0 ExtProc('dup')
     D   fildes                      10I 0 Value

      *--------------------------------------------------------------------
      * Duplicate open file descriptor to another descriptor
      *
      * int dup2(int fildes, int fildes2)
      *--------------------------------------------------------------------
     D dup2            PR            10I 0 ExtProc('dup2')
     D   fildes                      10I 0 Value
     D   fildes2                     10I 0 Value

      *--------------------------------------------------------------------
      * Determine file accessibility for a class of users by descriptor
      *
      * int faccessx(int filedes, int amode, int who)
      *--------------------------------------------------------------------
     D faccessx        PR            10I 0 ExtProc('faccessx')
     D   fildes                      10I 0 Value
     D   amode                       10I 0 Value
     D   who                         10I 0 Value

      *--------------------------------------------------------------------
      * Change Current Directory by Descriptor
      *
      * int fchdir(int fildes)
      *--------------------------------------------------------------------
     D fchdir          PR            10I 0 ExtProc('fchdir')
     D   fildes                      10I 0 value

      *--------------------------------------------------------------------
      * Change file authorizations by descriptor
      *
      * int fchmod(int fildes, mode_t mode)
      *--------------------------------------------------------------------
     D fchmod          PR            10I 0 ExtProc('fchmod')
     D   fildes                      10I 0 Value
     D   mode                        10U 0 Value

      *--------------------------------------------------------------------
      * Change Owner and Group of File by Descriptor
      *
      * int fchown(int fildes, uid_t owner, gid_t group)
      *--------------------------------------------------------------------
     D fchown          PR            10I 0 ExtProc('fchown')
     D   fildes                      10I 0 Value
     D   owner                       10U 0 Value
     D   group                       10U 0 Value

      *--------------------------------------------------------------------
      * Perform File Control
      *
      * int fcntl(int fildes, int cmd, . . .)
      *
      * Note:  Because the same fcntl() API is used for IFS and sockets,
      *        it's conditionally defined here.  If it's defined with
      *        the same conditions in the sockets /copy member, there
      *        will be no conflict.
      *--------------------------------------------------------------------
     D/if not defined(FCNTL_PROTOTYPE)
     D fcntl           PR            10I 0 ExtProc('fcntl')
     D   fildes                      10I 0 Value
     D   cmd                         10I 0 Value
     D   arg                         10I 0 Value options(*nopass)
     D/define FCNTL_PROTOTYPE
     D/endif

      *--------------------------------------------------------------------
      * Get configurable path name variables by descriptor
      *
      * long fpathconf(int fildes, int name)
      *--------------------------------------------------------------------
     D fpathconf       PR            10I 0 ExtProc('fpathconf')
     D   fildes                      10I 0 Value
     D   name                        10I 0 Value

      *--------------------------------------------------------------------
      * Get File Information by Descriptor
      *
      * int fstat(int fildes, struct stat *buf)
      *--------------------------------------------------------------------
     D fstat           PR            10I 0 ExtProc('fstat')
     D   fildes                      10I 0 Value
     D   buf                               likeds(statds)

      *--------------------------------------------------------------------
      * Get File Information by Descriptor, Large File Enabled
      *
      * int fstat64(int fildes, struct stat *buf)
      *--------------------------------------------------------------------
     D fstat64         PR            10I 0 ExtProc('fstat64')
     D   fildes                      10I 0 Value
     D   buf                               likeds(statds64)

      *--------------------------------------------------------------------
      * fstatvfs() -- Get file system status by descriptor
      *
      *  fildes = (input) file descriptor to use to locate file system
      *     buf = (output) data structure containing file system info
      *
      * Returns 0 if successful, -1 upon error.
      * (error information is returned via the "errno" variable)
      *--------------------------------------------------------------------
     D fstatvfs        PR            10I 0 ExtProc('fstatvfs64')
     D   fildes                      10I 0 value
     D   buf                               like(ds_statvfs)

      *--------------------------------------------------------------------
      * Synchronize Changes to file
      *
      * int fsync(int fildes)
      *--------------------------------------------------------------------
     D fsync           PR            10I 0 ExtProc('fsync')
     D   fildes                      10I 0 Value

      *--------------------------------------------------------------------
      * Truncate file
      *
      * int ftruncate(int fildes, off_t length)
      *--------------------------------------------------------------------
     D ftruncate       PR            10I 0 ExtProc('ftruncate')
     D   fildes                      10I 0 Value
     D   length                      10I 0 Value

      *--------------------------------------------------------------------
      * Truncate file, large file enabled
      *
      * int ftruncate64(int fildes, off64_t length)
      *--------------------------------------------------------------------
     D ftruncate64     PR            10I 0 ExtProc('ftruncate64')
     D   fildes                      10I 0 Value
     D   length                      20I 0 Value

      *--------------------------------------------------------------------
      * Get current working directory
      *
      * char *getcwd(char *buf, size_t size)
      *--------------------------------------------------------------------
     D getcwd          PR              *   ExtProc('getcwd')
     D   buf                           *   Value
     D   size                        10U 0 Value

      *--------------------------------------------------------------------
      * Get effective group ID
      *
      * gid_t getegid(void)
      *--------------------------------------------------------------------
     D getegid         PR            10U 0 ExtProc('getegid')

      *--------------------------------------------------------------------
      * Get effective user ID
      *
      * uid_t geteuid(void)
      *--------------------------------------------------------------------
     D geteuid         PR            10U 0 ExtProc('geteuid')

      *--------------------------------------------------------------------
      * Get Real Group ID
      *
      * gid_t getgid(void)
      *--------------------------------------------------------------------
     D getgid          PR            10U 0 ExtProc('getgid')

      *--------------------------------------------------------------------
      * Get group information from group ID
      *
      * struct group *getgrgid(gid_t gid)
      *--------------------------------------------------------------------
     D getgrgid        PR              *   ExtProc('getgrgid')
     D   gid                         10U 0 VALUE

      *--------------------------------------------------------------------
      * Get group info using group name
      *
      * struct group  *getgrnam(const char *name)
      *--------------------------------------------------------------------
     D getgrnam        PR              *   ExtProc('getgrnam')
     D   name                          *   VALUE

      *--------------------------------------------------------------------
      * Get group IDs
      *
      * int getgroups(int gidsetsize, gid_t grouplist[])
      *--------------------------------------------------------------------
     D getgroups       PR              *   ExtProc('getgroups')
     D   gidsetsize                  10I 0 value
     D   grouplist                   10U 0 dim(256) options(*varsize)

      *--------------------------------------------------------------------
      * Get user information by user-name
      *
      * (Don't let the name mislead you, this does not return the password,
      *  the user info database on unix systems is called "passwd",
      *  therefore, getting the user info is called "getpw")
      *
      * struct passwd *getpwnam(const char *name)
      *--------------------------------------------------------------------
     D getpwnam        PR              *   ExtProc('getpwnam')
     D   name                          *   Value options(*string)

      *--------------------------------------------------------------------
      * Get user information by user-id number
      *
      * (Don't let the name mislead you, this does not return the password,
      *  the user info database on unix systems is called "passwd",
      *  therefore, getting the user info is called "getpw")
      *
      * struct passwd *getpwuid(uid_t uid)
      *--------------------------------------------------------------------
     D getpwuid        PR              *   extproc('getpwuid')
     D   uid                         10U 0 Value

      *--------------------------------------------------------------------
      * Get Real User-ID
      *
      * uid_t getuid(void)
      *--------------------------------------------------------------------
     D getuid          PR            10U 0 ExtProc('getuid')

      *--------------------------------------------------------------------
      * Perform I/O Control Request
      *
      * int ioctl(int fildes, unsigned long req, ...)
      *--------------------------------------------------------------------
     D ioctl           PR            10I 0 ExtProc('ioctl')
     D   fildes                      10I 0 Value
     D   req                         10U 0 Value
     D   arg                           *   Value

      *--------------------------------------------------------------------
      * Change Owner/Group of symbolic link
      *
      * int lchown(const char *path, uid_t owner, gid_t group)
      *
      * NOTE: for non-symlinks, this behaves identically to chown().
      *       for symlinks, this changes ownership of the link, whereas
      *       chown() changes ownership of the file the link points to.
      *--------------------------------------------------------------------
     D lchown          PR            10I 0 ExtProc('lchown')
     D   path                          *   Value options(*string)
     D   owner                       10U 0 Value
     D   group                       10U 0 Value

      *--------------------------------------------------------------------
      * Create Hard Link to File
      *
      * int link(const char *existing, const char *new)
      *--------------------------------------------------------------------
     D link            PR            10I 0 ExtProc('link')
     D   existing                      *   Value options(*string)
     D   new                           *   Value options(*string)

      *--------------------------------------------------------------------
      * Set File Read/Write Offset
      *
      * off_t lseek(int fildes, off_t offset, int whence)
      *--------------------------------------------------------------------
     D lseek           PR            10I 0 ExtProc('lseek')
     D   fildes                      10I 0 value
     D   offset                      10I 0 value
     D   whence                      10I 0 value

      *--------------------------------------------------------------------
      * Set File Read/Write Offset, Large File Enabled
      *
      * off64_t lseek64(int fildes, off64_t offset, int whence)
      *--------------------------------------------------------------------
     D lseek64         PR            20I 0 ExtProc('lseek64')
     D   fildes                      10I 0 value
     D   offset                      20I 0 value
     D   whence                      10I 0 value

      *--------------------------------------------------------------------
      * Get File or Link Information
      *
      * int lstat(const char *path, struct stat *buf)
      *
      * NOTE: for non-symlinks, this behaves identically to stat().
      *       for symlinks, this gets information about the link, whereas
      *       stat() gets information about the file the link points to.
      *--------------------------------------------------------------------
     D lstat           PR            10I 0 ExtProc('lstat')
     D   path                          *   Value options(*string)
     D   buf                               likeds(statds)

      *--------------------------------------------------------------------
      * Get File or Link Information, Large File Enabled
      *
      * int lstat64(const char *path, struct stat64 *buf)
      *
      * NOTE: for non-symlinks, this behaves identically to stat().
      *       for symlinks, this gets information about the link, whereas
      *       stat() gets information about the file the link points to.
      *--------------------------------------------------------------------
     D lstat64         PR            10I 0 ExtProc('lstat64')
     D   path                          *   Value options(*string)
     D   buf                               likeds(statds64)

      *--------------------------------------------------------------------
      * Make Directory
      *
      * int mkdir(const char *path, mode_t mode)
      *--------------------------------------------------------------------
     D mkdir           PR            10I 0 ExtProc('mkdir')
     D   path                          *   Value options(*string)
     D   mode                        10U 0 Value

      *--------------------------------------------------------------------
      * Make FIFO Special File
      *
      * int mkfifo(const char *path, mode_t mode)
      *--------------------------------------------------------------------
     D mkfifo          PR            10I 0 ExtProc('mkfifo')
     D   path                          *   Value options(*string)
     D   mode                        10U 0 Value

      *--------------------------------------------------------------------
      * Open a File
      *
      * int open(const char *path, int oflag, . . .);
      *--------------------------------------------------------------------
     D open            PR            10I 0 ExtProc('open')
     D  path                           *   value options(*string)
     D  openflags                    10I 0 value
     D  mode                         10U 0 value options(*nopass)
     D  ccsid                        10U 0 value options(*nopass)
     D  txtcreatid                   10U 0 value options(*nopass)

      *--------------------------------------------------------------------
      * Open a File, Large File Enabled
      *
      * int open64(const char *path, int oflag, . . .);
      *
      * NOTE: This is identical to calling open(), except that the
      *       O_LARGEFILE flag is automatically supplied.
      *--------------------------------------------------------------------
     D open64          PR            10I 0 ExtProc('open64')
     D  filename                       *   value options(*string)
     D  openflags                    10I 0 value
     D  mode                         10U 0 value options(*nopass)
     D  codepage                     10U 0 value options(*nopass)
     D  txtcreatid                   10U 0 value options(*nopass)

      *--------------------------------------------------------------------
      * Open a Directory
      *
      * DIR *opendir(const char *dirname)
      *--------------------------------------------------------------------
     D opendir         PR              *   EXTPROC('opendir')
     D  dirname                        *   VALUE options(*string)

      *--------------------------------------------------------------------
      * Get configurable path name variables
      *
      * long pathconf(const char *path, int name)
      *--------------------------------------------------------------------
     D pathconf        PR            10I 0 ExtProc('pathconf')
     D   path                          *   Value options(*string)
     D   name                        10I 0 Value

      *--------------------------------------------------------------------
      * Create interprocess channel
      *
      * int pipe(int fildes[2]);
      *--------------------------------------------------------------------
     D pipe            PR            10I 0 ExtProc('pipe')
     D   fildes                      10I 0 dim(2)

      *--------------------------------------------------------------------
      * Read from Descriptor with Offset
      *
      * ssize_t pread(int filedes, void *buf, size_t nbyte, off_t offset);
      *--------------------------------------------------------------------
     D pread           PR            10I 0 ExtProc('pread')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value
     D   offset                      10I 0 value

      *--------------------------------------------------------------------
      * Read from Descriptor with Offset, Large File Enabled
      *
      * ssize_t pread64(int filedes, void *buf, size_t nbyte,
      *                 size_t nbyte, off64_t offset);
      *--------------------------------------------------------------------
     D pread64         PR            10I 0 ExtProc('pread64')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value
     D   offset                      20I 0 value

      *--------------------------------------------------------------------
      * Write to Descriptor with Offset
      *
      * ssize_t pwrite(int filedes, const void *buf,
      *                size_t nbyte, off_t offset);
      *--------------------------------------------------------------------
     D pwrite          PR            10I 0 ExtProc('pwrite')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value
     D   offset                      10I 0 value

      *--------------------------------------------------------------------
      * Write to Descriptor with Offset, Large File Enabled
      *
      * ssize_t pwrite64(int filedes, const void *buf,
      *                  size_t nbyte, off64_t offset);
      *--------------------------------------------------------------------
     D pwrite64        PR            10I 0 ExtProc('pwrite64')
     D   fildes                      10I 0 value
     D   buf                           *   value
     D   nbyte                       10U 0 value
     D   offset                      20I 0 value

      *--------------------------------------------------------------------
      * Perform Miscellaneous file system functions
      *--------------------------------------------------------------------
     D QP0FPTOS        PR                  ExtPgm('QP0FPTOS')
     D   Function                    32A   const
     D   Exten1                       6A   const options(*nopass)
     D   Exten2                       3A   const options(*nopass)

      *--------------------------------------------------------------------
      * Read From a File
      *
      * ssize_t read(int fildes, void *buffer, size_t bytes);
      *--------------------------------------------------------------------
     D read            PR            10I 0 ExtProc('read')
     D  fildes                       10i 0 value
     D  buf                            *   value
     D  bytes                        10U 0 value

      *--------------------------------------------------------------------
      * Read Directory Entry
      *
      * struct dirent *readdir(DIR *dirp)
      *--------------------------------------------------------------------
     D readdir         PR              *   EXTPROC('readdir')
     D  dirp                           *   VALUE

      *--------------------------------------------------------------------
      * Read Value of Symbolic Link
      *
      * int readlink(const char *path, char *buf, size_t bufsiz)
      *--------------------------------------------------------------------
     D readlink        PR            10I 0 ExtProc('readlink')
     D   path                          *   value options(*string)
     D   buf                           *   value
     D   bufsiz                      10U 0 value

      *--------------------------------------------------------------------
      * Read From Descriptor using Multiple Buffers
      *
      * int readv(int fildes, struct iovec *io_vector[], int vector_len);
      *--------------------------------------------------------------------
     D readv           PR            10I 0 ExtProc('readv')
     D  fildes                       10i 0 value
     D  io_vector                          like(iovec)
     D                                     dim(256) options(*varsize)
     D  vector_len                   10I 0 value

      *--------------------------------------------------------------------
      * Rename File or Directory
      *
      * int rename(const char *old, const char *new)
      *
      *  Note: By defailt, if a file with the new name already exists,
      *        rename will fail with an error.  If you define
      *        RENAMEUNLINK and a file with the new name already exists
      *        it will be unlinked prior to renaming.
      *--------------------------------------------------------------------
      /if defined(RENAMEUNLINK)
     D rename          PR            10I 0 ExtProc('Qp0lRenameUnlink')
     D   old                           *   Value options(*string)
     D   new                           *   Value options(*string)
      /else
     D rename          PR            10I 0 ExtProc('Qp0lRenameKeep')
     D   old                           *   Value options(*string)
     D   new                           *   Value options(*string)
      /endif

      *--------------------------------------------------------------------
      * Reset Directory Stream to Beginning
      *
      * void rewinddir(DIR *dirp)
      *--------------------------------------------------------------------
     D rewinddir       PR                  ExtProc('rewinddir')
     D   dirp                          *   value


      *--------------------------------------------------------------------
      * Remove Directory
      *
      * int rmdir(const char *path)
      *--------------------------------------------------------------------
     D rmdir           PR            10I 0 ExtProc('rmdir')
     D   path                          *   value options(*string)

      *--------------------------------------------------------------------
      * Get File Information
      *
      * int stat(const char *path, struct stat *buf)
      *--------------------------------------------------------------------
     D stat            PR            10I 0 ExtProc('stat')
     D   path                          *   value options(*string)
     D   buf                               likeds(statds)


      *--------------------------------------------------------------------
      * Get File Information, Large File Enabled
      *
      * int stat(const char *path, struct stat64 *buf)
      *--------------------------------------------------------------------
     D stat64          PR            10I 0 ExtProc('stat64')
     D   path                          *   value options(*string)
     D   buf                               likeds(statds64)


      *--------------------------------------------------------------------
      * statvfs() -- Get file system status
      *
      *    path = (input) pathname of a link ("file") in the IFS.
      *     buf = (output) data structure containing file system info
      *
      * Returns 0 if successful, -1 upon error.
      * (error information is returned via the "errno" variable)
      *--------------------------------------------------------------------
     D statvfs         PR            10I 0 ExtProc('statvfs64')
     D   path                          *   value options(*string)
     D   buf                               like(ds_statvfs)

      *--------------------------------------------------------------------
      * Make Symbolic Link
      *
      * int symlink(const char *pname, const char *slink)
      *--------------------------------------------------------------------
     D symlink         PR            10I 0 ExtProc('symlink')
     D   pname                         *   value options(*string)
     D   slink                         *   value options(*string)

      *--------------------------------------------------------------------
      * Get system configuration variables
      *
      * long sysconf(int name)
      *--------------------------------------------------------------------
     D sysconf         PR            10I 0 ExtProc('sysconf')
     D   name                        10I 0 Value

      *--------------------------------------------------------------------
      * Set Authorization Mask for Job
      *
      * mode_t umask(mode_t cmask)
      *--------------------------------------------------------------------
     D umask           PR            10U 0 ExtProc('umask')
     D   cmask                       10U 0 Value

      *--------------------------------------------------------------------
      * Remove Link to File.  (Deletes Directory Entry for File, and if
      *    this was the last link to the file data, the file itself is
      *    also deleted)
      *
      * int unlink(const char *path)
      *--------------------------------------------------------------------
     D unlink          PR            10I 0 ExtProc('unlink')
     D   path                          *   Value options(*string)

      *--------------------------------------------------------------------
      * Set File Access & Modification Times
      *
      * int utime(const char *path, const struct utimbuf *times)
      *--------------------------------------------------------------------
     D utime           PR            10I 0 ExtProc('utime')
     D   path                          *   value options(*string)
     D   times                             likeds(utimbuf) options(*omit)

      *--------------------------------------------------------------------
      * Write to a file
      *
      * ssize_t write(int fildes, const void *buf, size_t bytes)
      *--------------------------------------------------------------------
     D write           PR            10I 0 ExtProc('write')
     D  fildes                       10i 0 value
     D  buf                            *   value
     D  bytes                        10U 0 value

      *--------------------------------------------------------------------
      * Write to a file using (with type A field in prototype)
      *
      * ssize_t write(int fildes, const void *buf, size_t bytes)
      *--------------------------------------------------------------------
     D writeA          PR            10I 0 ExtProc('write')
     D  fildes                       10i 0 value
     D  buf                       65535A   const options(*varsize)
     D  bytes                        10U 0 value

      *--------------------------------------------------------------------
      * Write to descriptor using multiple buffers
      *
      * int writev(int fildes, struct iovec *iovector[], int vector_len);
      *--------------------------------------------------------------------
     D writev          PR            10I 0 ExtProc('writev')
     D  fildes                       10i 0 value
     D  io_vector                          like(iovec)
     D                                     dim(256) options(*varsize)
     D  vector_len                   10I 0 value


      * Get errno value
     d errno           S             10i 0 based(p_errno)
     d GetErrno        PR              *   extproc('__errno')

      * Set Pointer to Run-Time Error Message
     d errstr          S           1024a   based(p_errstr)
     d strerror        PR              *   extproc('strerror')
     d  errno                        10i 0 value

     d dspVal          s             52

     D LDA            UDS                  dtaara(*LDA)
     D  MLIND                  1     40
     D  MLFRM                 41    160
     D  MLFRM6                41    100
     D  MLSUBJ               161    220
     D  MLTXT1               221    285
     D  MLTXT2               286    350
     D  MLPATH               221    350
     D  MLTXT3               351    415
     D  MLTXT4               416    480
     D  MLTXT5               481    545
     D  MLTYPE               546    546
     D  MLTO60               547    606
     D  MLTO                 547    666
     D  IFLIST               547    556
     D  IFREPL               557    557
     D  MLDIST               667    667
     d  mlFmt                668    677
     d  mlCdPg               678    682
     d  mlIgBa               683    683
     D  mlspml               684    684
     d  iflnam               833    842

     d memcpy          pr              *   extproc('memcpy')
     d  Target                         *   value
     d  Source                         *   value
     d  Length                       10u 0 value

     d upper           c                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     d lower           c                   'abcdefghijklmnopqrstuvwxyz'
     d specialChar     c                   '`!@#$%^&*()-+=~[]{}|\/:;",./?<>'''''

     d getLnkDef       pr            10i 0
     d inputDoctype                  10

       // Return just the file name from a given path.
     d fileNameFromPath...
     d                 pr           128
     d pathIn                       256    const

       // External applications
     d getCodePages    pr                  extpgm('SPYCDPAG')
     d  fromCCSID                     5    const
     d  toCCSID                       5    const
     d  fromTable                   256
     d  toTable                     256

     d strDlm          s              1    inz(' ')
     d fldDlm          s              1    inz(' ')

     d printReport     pr                  extpgm('MCDDPRPT')
     d inRptNam                      10    const
     d inJobIdDS                     26    const
     d inDatfo                        7    const
     d inSplfNbr                     10i 0 const
     d inOutqDS                      20    const
     d inCopies                       3  0 const
     d inCaller                      10    const
     d inFrPage                       9  0 const
     d inToPage                       9  0 const
     d inPrinter                     10    const
     d inPrtf                        10    const
     d inPrtfLib                     10    const
     d inSbmJob                       1    const
     d inPgTbl                       10    const
     d inFolderDS                    20    const
     d operation                      1    const
     d outMsgID                       7
     d outMsgDta                    100

     d print2038       pr                  extpgm('MAG2038')
     d  RPTNAM                       10    const
     d  OUTFRM                       10    const
     d  RPTUD                        10    const
     d  FRMPAG                        7  0 const
     d  TOPAGE                        7  0 const
     d  OUTQ                         10    const
     d  OUTQL                        10    const
     d  PRTF                         10    const
     d  PRTLIB                       10    const
     d  FRMCL#                        3  0 const
     d  TOCOL#                        3  0 const
     d  COPIES                        3  0 const
     d  WRITER                       10    const
     d  OUTFIL                       10    const
     d  OUTFLB                       10    const
     d  FILLOC                        1    const
     d  OPTFIL                       10    const
     d  NUMWND                        3  0 const
     d  #RL                           3  0 const
     d  COLSCN                        3  0 const
     d  PLCSFA                        9  0 const
     d  PLCSFD                        9  0 const
     d  PLCSFP                        9  0 const
     d  PRTWND                        1    const
     d  @FLDR                        10    const
     d  @FLDLB                       10    const
     d  SPYNUM                       10    const
     d  PTABLE                       20    const
     d  CVRPAG                        7    const
     d  DUPLEX                        4    const
     d  ORIENT                       10    const
     d  PTRTYP                        6    const
     d  PTRNOD                       17    const
     d  CVRMBR                       10    const
     d  PAPSIZ                       10    const
     d  DRAWER                        4    const
     d  eNotesPrint                   1    const

     d fmtMsg          pr                  extpgm('MAG1033')
     d  action                        1    const
     d  msgFil                       20    const
     d  errStruct                          likeds(msg)
     d  rtnText                      80
     d run             pr            10i 0 extproc('system')
     d  cmd                            *   value options(*string)

     d getSeqNum       pr            10i 0
     d  objectID                     10    const
     d  seqNbr                       10i 0 const

     d getnotes        s             80    dim(3) ctdata
     d crtnottbl       s             80    dim(13) ctdata
     d noteTypesA      s              2    dim(7) ctdata
     d noteTypeText    s             20    dim(7) alt(noteTypesA)
     d csvHeaderA      s             20    dim(19) ctdata
     d onBaseExtKey    s              4    dim(100) ctdata
     d onBaseExtVal    s              3    dim(100) alt(onBaseExtKey)

     d dts             ds
     d dtsA                         256    dim(240)
     d  fcfc                          1    overlay(dtsA)
     d  lessPage#                   247    overlay(dtsA)
     d  payLoad                     246    overlay(dtsA:2)

     d rtnatr          ds            80
     d  rptwid                 1      9  0
     d  paglns                10     18  0
     d  form                  19     28
     d  rptlpi                29     37  0
     d  rptcpi                38     46  0
     d  rptrtt                47     47
     d  rptovlyn              48     48

     d path            s            256

       // External programs.
     d pageRtv         pr                  extpgm('SPYPGRTV')
     d  repind                       10    const
     d  opcode                        5    const
     d  page#                         7  0 const
     d  RRN                           9  0 const
     d  DTS                                like(dts)
     d  rtnRec                        9  0
     d  rtnAtr                             like(rtnAtr)
     d  calLnk                        1    const
     d  lkval1                       70    const
     d  lkval2                       70    const
     d  lkval3                       70    const
     d  lkval4                       70    const
     d  lkval5                       70    const
     d  lkval6                       70    const
     d  lkval7                       70    const
     d  rtnCode                       2
     d  msgid                         7
     d  msgDta                      100
     d  file#                         9  0 const
     d  segOffSets                   11  0 const
     d  useForm                       1    const

     d spyIFS          pr                  extpgm('SPYIFS')
     d  opcode                       10    const
     d  path                        256    options(*nopass)
     d  data                               like(writeData) options(*nopass)
     d  dataLen                      10i 0 const options(*nopass)
     d  frCCSID                       5    const options(*nopass)
     d  toCCSID                       5    const options(*nopass)
     d  msgID                         7    options(*nopass)

     D getImageData    pr                  extpgm('MAG1092')
     d  opCode                       10    const
     d  batch#                       10    const options(*nopass)
     d  imgRRN                        9  0 const options(*nopass)
     d  startOffSet                   9  0 options(*nopass)
     d  bytesRequest                  9  0 options(*nopass)
     d  cacheFlag                     1    options(*nopass)
     d  imageSize                     9  0 options(*nopass)
     d  bytesRtn                      9  0 options(*nopass)
     d  nextRRN                       9  0 options(*nopass)
     d  attrData                           likeds(atrdta) options(*nopass)
     d  data                               like(imgDtaRtn_t) options(*nopass)
     d                                     dim(%elem(imgDtaRtn_t))
     d  returnCode                    7    options(*nopass)
     d  rtnData                     100    options(*nopass)

       // Subprocedures
     d bldStmt         pr
     d  statementType                 1    const
     d rcvLstMsg       pr            10i 0
     d  rtnMsg                       80
     d doFetch         pr
     d  type                          1    const
     d exportReport    pr            10I 0
     d exportNativePDF...
     d                 pr            10i 0
     d writeImages     pr            10I 0
     d formatNdxFile   pr

       // CSV input index format.
     d csv             ds                  qualified inz
     D  docType                      10
     D  id                           10
     D  seq                          10i 0
     D  n1                           99
     D  n2                           99
     D  n3                           99
     D  n4                           99
     D  n5                           99
     D  n6                           99
     D  n7                           99
     D  date                          8
     D  ndxType                       1
     D  spg                          10i 0
     D  epg                          10i 0

       // Variables, constants and data structures.
     d imgDtaRtn_t     s           1024    dim(128)

     d expCfgDta       ds           256    dtaara qualified inz
     d  key                          16    overlay(expCfgDta:1)
     d  expiry                        8    overlay(expCfgDta:17)
     d  stopIndicator                 1    overlay(expCfgDta:25)
     d  rptNdxFmt                     1    overlay(expCfgDta:26)
     d  ifsDivDir                     1    overlay(expCfgDta:27)
     d  addHdrRcd                     1    overlay(expCfgDta:28)
     d  crtDatFmt                    10    overlay(expCfgDta:29)
     d  expRptsAS                     1    overlay(expCfgDta:39)
     d  expNotes                      1    overlay(expCfgDta:40)
     d  csvFormat                     1    overlay(expCfgDta:41)
     d  buildID                       4    overlay(expCfgDta:42)
     d  nameOnly                      1    overlay(expCfgDta:46)
     d  noteHI                        1    overlay(expCfgDta:47)
     d  noteSN                        1    overlay(expCfgDta:48)
     d  noteBO                        1    overlay(expCfgDta:49)
     d  noteTN                        1    overlay(expCfgDta:50)
     d  noteBL                        1    overlay(expCfgDta:51)
     d  noteAU                        1    overlay(expCfgDta:52)
     d  strDlmt                       9    overlay(expCfgDta:53)
     d  fldDlmt                       4    overlay(expCfgDta:62)
     d  debug                         1    overlay(expCfgDta:66)
     d  cambellCounty                 1    overlay(expCfgDta:67)

     d noteFlagA       s              1    dim(6)

     d wrkNdxRcd       ds                  qualified
     d  path                        256
     d  class                        15
     d  archType                     10
     d  id                           15
     d  seqNbr                       10
     d  blank                         5
     d  createDate                   15
     d  ndx1                         70
     d  ndx2                         70
     d  ndx3                         70
     d  ndx4                         70
     d  ndx5                         70
     d  ndx6                         70
     d  ndx7                         70
     d                sds
     d  pgmlib                81     90
     d jobNam                244    253
     d user                  254    263
     d jobNbr                264    269

     d rpt             ds                  qualified
     d  fldr                         10
     d  fldrlb                       10
     d  filnam                       10
     d  jobnam                       10
     d  usrnam                       10
     d  jobnum                        6
     d  filnum                       10i 0
     d  frmtyp                       10
     d  usrdta                       10
     d  datfop                       10i 0
     d  timfop                       10i 0
     d  devcls                       10
     d  ovrlin                        9p 0
     d  prtfon                       10
     d  pagrot                        9p 0
     d  maxsiz                        9p 0
     d  adsf                          9p 0
     d  expdat                        9p 0
     d  pgmopf                       10
     d  repind                       10
     d  totpag                        9p 0
     d  lpi                           9p 0
     d  cpi                           9p 0
     d  locsfa                        9p 0
     d  locsfd                        9p 0
     d  locsfp                        9p 0
     d  reploc                        1
     d  ofrnam                       10
     d  apftyp                        1
     d  mdatop                        9p 0
     d  mtimop                        9p 0
     d  rpttyp                       10
     d  ldxnam                       10
     d  lxseq                         9p 0
     d  spg                           9p 0
     d  epg                           9p 0
     d  lxiv1                        99
     d  lxiv2                        99
     d  lxiv3                        99
     d  lxiv4                        99
     d  lxiv5                        99
     d  lxiv6                        99
     d  lxiv7                        99
     d  lxiv8                         8

     d img             ds                  qualified
     d  idrtyp                       10
     d  idbnum                       10
     d  idfld                        10
     d  iddscn                       10i 0
     d  ldxnam                       10
     d  lxseq                         9p 0
     d  spg                           9p 0
     d  epg                           9p 0
     d  lxiv1                        99
     d  lxiv2                        99
     d  lxiv3                        99
     d  lxiv4                        99
     d  lxiv5                        99
     d  lxiv6                        99
     d  lxiv7                        99
     d  lxiv8                         8

     d msgID           s              7
     d msgDta          s            132
     d msgTyp          s             10
     d msg             ds                  qualified
     d  len                          10i 0
     d  reserved1                     4
     d  id                            7
     d  reserved2                     1
     d  dta                         100
     d PSCON           c                   'PSCON     *LIBL     '
     d msgRtn          s             80
     d curObjTyp       s              1
     d linkDef       e ds                  extname(RLNKDEF) qualified
     d printFile       s             10
     d printFileLib    s             10
     d linkName        s             10    dim(7) based(linkNameP)
     d noteHeader    e ds                  extname(MNOTDIR)
     d BS_LINK         c                   'L'
     d BS_DEDUP        c                   'D'
     d BS_NATPDF       c                   'P'
     d OLDCSV          c                   '0'
     d NEWCSV          c                   '1'
     d SQ              c                   ''''

     d reportDateISO   s              8p 0
     d links           ds                  likeds(link_t)
     d cfgIndices      s             70    dim(7) based(cfgNdxP)
     d cfgNdxP         s               *   inz(%addr(cfgNdx1))
     d i               s             10i 0
     d batchExpErr     s               n

     d RRN             s              9  0 inz
     d rtnRec          s              9  0
     d rtnCode         s              2    inz('00')
     d rFil#           s              9  0
     d roffs           s             11  0
     d opcode          s             10
     d CRLF            c                   x'0D25'
     d dataLen         s             10i 0
     d msgDta100       s            100
     d writeData       s          65535
     d fileSeq         s             10i 0
     d lastID          s             10
     d reportName      s             20
     d ovrFldDir       s             10
     d fldr            s             10
     d repind          s             10
     d totpag          s              9p 0
     d page#           s              7  0
     d toDate          s               d   datfmt(*iso)
     d EXPRPTOPN       c                   -1
     d EXPRPTPGRTV     c                   -2
     d EXPRPTWRT       c                   -3
     d EXPNOLNKFIL     c                   -4
     d EXPNATIVEPDF    c                   -5
     d expRptRtn       s             10i 0
     d wrkFile         s             10
     d hdrFile         s             10

     D ATRDTA          DS          1024
     D  FMTSPY                 1      3
     D  FMTVER                 1      5
     D  PCIDX#                 6      8
     D  PCSIZE                 9     17
     D  PCFILE                18     42
     D  PCEXT                 43     47
     D  PCDATE                48     55
     D  PCTIME                56     61
     D  PCPATH                62    311
     D  PCUDAT               312    319
     D  PCUTIM               320    325
     D  PCUSR                326    335
     D  PCNODE               336    352
     D  PCOSV                353    358
     D  PCSPYV               359    364
     D  PCSYS                365    369
     d  PCNAME               371    626
     d  pcLnkIdx#            979    980u 0
     d  pcUsrIdx#            981    982u 0
     d  pcBase36             983    983
     d  pcHashA              984   1015
     d  PCBCNT              1016   1020
     d  PCBCNT#             1016   1020s 0
     d  PCRID               1021   1024

     d rc              s             10i 0
     d tmpNdxPath      s            256
     d tmpNdxFile      s             10
     d basePath        s            256
     d ndxVals         s             99    dim(7) based(ndxValsP)
     d ndxValsP        s               *   inz(%addr(links.ndx1))
     d csvPath         s            256
     d csvFH           s             10i 0
     d imageFH         s             10i 0
     d fTable          s            256
     d tTable          s            256
     d csvRptTyp       s             10
     d csvFolder       s             10
     d csvYYYYMM       s              6
     d apfFile         s             10
     d apfDta          s           4079
     d rptName         s             10

     D exportNotes     PR
     D  docID                        10A   CONST
     D  seq                          10i 0 const

     D addIndexTest    PR
     d  stmt                       1024
     d  stmtType                      1    const
     d lastBatch       s             10    inz
     d exportByCSV     s               n   inz(*off)
     d csvNoteFH       s             10i 0
     d noteData        s           1024

     D exportByCSVInput...
     D                 PR


     D* --------------------------------------------------
     D* Prototype for procedure: setup4output
     D* --------------------------------------------------
     Dsetup4output     PR
     d pathBase                     256
     d timeKey                        6
     d pdfPathRtn                   256
     d pdfPathRtn      s            256
     d timeKey         s              6

     d extFromPath     pr             4
     d  inPath                      256

     d outfrm          s             10    inz('*STD')
     d rptud           s             10    inz('*ORIG')
     d spg             s                   like(rpt.spg)
     d epg             s                   like(rpt.epg)

     D*      SQL COMMUNICATION AREA                                             SQL
     D SQLCA           DS                                                       SQL
     D  SQLCAID                       8A   INZ(X'0000000000000000')             SQL
     D  SQLAID                        8A   OVERLAY(SQLCAID)                     SQL
     D  SQLCABC                      10I 0                                      SQL
     D  SQLABC                        9B 0 OVERLAY(SQLCABC)                     SQL
     D  SQLCODE                      10I 0                                      SQL
     D  SQLCOD                        9B 0 OVERLAY(SQLCODE)                     SQL
     D  SQLERRML                      5I 0                                      SQL
     D  SQLERL                        4B 0 OVERLAY(SQLERRML)                    SQL
     D  SQLERRMC                     70A                                        SQL
     D  SQLERM                       70A   OVERLAY(SQLERRMC)                    SQL
     D  SQLERRP                       8A                                        SQL
     D  SQLERP                        8A   OVERLAY(SQLERRP)                     SQL
     D  SQLERR                       24A                                        SQL
     D   SQLER1                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER2                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER3                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER4                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER5                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLER6                       9B 0 OVERLAY(SQLERR:*NEXT)                SQL
     D   SQLERRD                     10I 0 DIM(6)  OVERLAY(SQLERR)              SQL
     D  SQLWRN                       11A                                        SQL
     D   SQLWN0                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN1                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN2                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN3                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN4                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN5                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN6                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN7                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN8                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWN9                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D   SQLWNA                       1A   OVERLAY(SQLWRN:*NEXT)                SQL
     D  SQLWARN                       1A   DIM(11) OVERLAY(SQLWRN)              SQL
     D  SQLSTATE                      5A                                        SQL
     D  SQLSTT                        5A   OVERLAY(SQLSTATE)                    SQL
     D*  END OF SQLCA                                                           SQL
     D  SQLROUTE       C                   CONST('QSYS/QSQROUTE')               SQL
     D  SQLOPEN        C                   CONST('QSYS/QSQLOPEN')               SQL
     D  SQLCLSE        C                   CONST('QSYS/QSQLCLSE')               SQL
     D  SQLCMIT        C                   CONST('QSYS/QSQLCMIT')               SQL
     D  SQFRD          C                   CONST(2)                             SQL
     D  SQFCRT         C                   CONST(8)                             SQL
     D  SQFOVR         C                   CONST(16)                            SQL
     D  SQFAPP         C                   CONST(32)                            SQL
     D  SQCALL000010   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D                 DS                                                       SELECT
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(11)                              statement number
     D  SQL_00002              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0')                             data is okay
     D  SQL_00004             10    128A                                        end of header
     D  SQL_00005            129    138A                                        RPT.RPTTYP
     D  SQL_00006            139    148A                                        PRINTFILE
     D  SQL_00007            149    158A                                        PRINTFILELIB
     D                 DS                                                       CLOSE
     D  SQL_00008              1      2B 0 INZ(128)                             length of header
     D  SQL_00009              3      4B 0 INZ(12)                              statement number
     D  SQL_00010              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00011              9      9A   INZ('0')                             data is okay
     D  SQL_00012             10    127A                                        end of header
     D  SQL_00013            128    128A                                        end of header
     c     *entry        plist
     c                   parm                    cfgFolderIn      10
     c                   parm                    cfgTypeIn        10
     c                   parm                    cfgFrDateIn       8
     c                   parm                    cfgToDateIn       8
     c                   parm                    cfgOutQIn        10
     c                   parm                    cfgOutQLibIn     10
     c                   parm                    cfgCvtPDFIn       1
     c                   parm                    indexIn1         70
     c                   parm                    indexIn2         70
     c                   parm                    indexIn3         70
     c                   parm                    indexIn4         70
     c                   parm                    indexIn5         70
     c                   parm                    indexIn6         70
     c                   parm                    indexIn7         70
     c                   parm                    cfgDirIn        128
     c                   parm                    csvDirIn        128
      /free

       //*exec sql
       //*  set option closqlcsr = *endmod, commit = *none;

       run('chgjob * jobmsgqfl(*wrap)');

       // Clear stop indicator on startup.
       in(e) *lock expCfgDta;
       expCfgDta.stopIndicator = '0';
       out expCfgDta;

       // Format string and field delimiter fields for CSV files.
       select;
       when expCfgDta.strDlmt = '*NONE';
       when expCfgDta.strDlmt = '*DBLQUOTE';
         strDlm = '"';
       other;
         strDlm = %trim(expCfgDta.strDlmt);
       endsl;
       if expCfgDta.fldDlmt = '*TAB';
         fldDlm = x'05';
       else;
         fldDlm = %trim(expCfgDta.fldDlmt);
       endif;

       // Code pages for character translation.
       getCodePages('00000':'01252':fTable:tTable);

       // Check if export is already running. Multiple exports are allowed to
       // run if called by command.
       if expCfgDta.debug <> 'Y'; // Debug option from config dtaara.
         if %parms = 0 and lockExport(LOCK_LOCK) <> OK;
           writeLog(' ':' ':' ':0:0:'Unable to lock export. Running?');
           exsr quit;
         endif;
       endif;

       // Validate key code and expiry.
       in expCfgDta;
       if validateKey(expCfgDta.key:expCfgDta.expiry:expCfgDta.expnotes) <> OK;
         writeLog(' ':' ':' ':0:0:'Invalid or expired keycode.');
         exsr quit;
       endif;

       // Clear the log of all errors so that the failed objects can be
       // retried.
       //*exec sql
       //*  delete from explog where left(logobjid, 1) in ('E', 'W');
          SQLER6 = 10;                                                          //SQL
          SQCALL000010(                                                         //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL

       // Started from interface vs command. No parms.
       // Config read from configuration file.
       if %parms = 0;
         chain 1 expcfg;
         if not %found;
           writeLog(' ':' ':' ':0:0:'No configuration found.');
           exsr quit;
         endif;
         // Bummer...pointer does not align on contiguous database fields.
         // Leaves 10 bytes of nulls at beg/end of index. Had to hard map.
         // No time to figure out at this time.
         // Pointer works okay with EXPORTCMD.
         cfgNdxP = %addr(cfgndx1);
         cfgIndices(1) = cfgndx1;
         cfgIndices(2) = cfgndx2;
         cfgIndices(3) = cfgndx3;
         cfgIndices(4) = cfgndx4;
         cfgIndices(5) = cfgndx5;
         cfgIndices(6) = cfgndx6;
         cfgIndices(7) = cfgndx7;
       endif;

       // Called by command. Parms passed.
       if %parms > 0;

         // Check if this is an export driven by CSV input file.
         exportByCSVInput();

         cfgFolder = cfgFolderIn;
         cfgType = cfgTypeIn;
         if cfgFrDateIn = ' ';
           cfgFrDate = %date('19750101':*iso0);
         else;
           cfgFrDate = %date(cfgFrDateIn:*iso0);
         endif;
         if cfgToDateIn = ' ';
           cfgToDate = %date();
         else;
           cfgToDate = %date(cfgToDateIn:*iso0);
         endif;
         cfgOutQ = cfgOutQIn;
         cfgOutQLib = cfgOutQLibIn;
         cfgCvtPDF = cfgCvtPDFIn;
         cfgDir = %str(%addr(cfgDirIn):128);
         cfgNdxP = %addr(indexIn1);

       endif;

       for i = 1 to %elem(cfgIndices);
         cfgIndices(i) = %xlate(lower:upper:cfgIndices(i));
       endfor;

       // Set note type filters array if annotations on.
       noteFlagA(1) = expcfgdta.noteHI;
       noteFlagA(2) = expcfgdta.noteSN;
       noteFlagA(3) = expcfgdta.noteBO;
       noteFlagA(4) = expcfgdta.noteTN;
       noteFlagA(5) = expcfgdta.noteBL;
       noteFlagA(6) = expcfgdta.noteAU;

       if exportByCSV;
         curObjTyp = OBJTYPALL;
       else;
         curObjTyp = getObjTyp(cfgType);
       endif;

       // If all types (reports & images) are requested for processing,
       // do reports first and then images.
       if curObjTyp = OBJTYPALL;
         curObjTyp = OBJTYPRPT;
         for i = 1 to 2;
           exsr processType;
           curObjTyp = OBJTYPIMG;
         endfor;
       else;
         exsr processType;
       endif;

       exsr quit;

       //***********************************************************************
       begsr processType;

         bldStmt(curObjTyp);
         doFetch(curObjTyp);
         if sqlcod = 100;
           writeLog(cfgFolder:cfgType:' ':0:0:
             'No data found or data already exported for criteria.');
         endif;

         // Retrieve the rlnkdef record after first read from input csv.
         if exportByCSV and sqlcod = 0;
           if curObjTyp = OBJTYPRPT;
             sqlcod = getLnkdef(rpt.rpttyp);
           else;
             sqlcod = getLnkdef(img.idrtyp);
           endif;
         endif;

         // Fetch printer file name and library if one exists.
         if curObjTyp = OBJTYPRPT;
       //*    exec sql
       //*      select rptrfl, rptrlb
       //*        into :printfile, :printfilelib
       //*        from rmaint
       //*        where rtypid = :rpt.rpttyp;
     C                   EVAL      SQL_00005    = RPT.RPTTYP                    SQL
     C                   Z-ADD     -4            SQLER6                         SQL   11
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00000                      SQL
     C     SQL_00003     IFEQ      '1'                                          SQL
     C                   EVAL      PRINTFILE = SQL_00006                        SQL
     C                   EVAL      PRINTFILELIB = SQL_00007                     SQL
     C                   END                                                    SQL
         endif;

         dow sqlcod = OK or sqlcod = 326; //326 more fields than host var.
           in expCfgDta;
           if expCfgDta.stopIndicator = '1';
             leave;
           endif;
           select;
           when curObjTyp = OBJTYPRPT;
             csvRptTyp = rpt.rpttyp;
             csvFolder = rpt.fldr;
             csvYYYYMM = %subst(%char(%date(rpt.datfop:*cymd):*iso0):1:6);
           when curObjTyp = OBJTYPIMG;
             csvRptTyp = img.idrtyp;
             csvFolder = img.idfld;
             csvYYYYMM = %subst(%trim(%char(img.iddscn)):1:6);
           endsl;
           basePath =  %trimr(cfgDir) + '/';
           csvPath = %trimr(cfgDir) + '/' + %trimr(csvRptTyp) + '.CSV' + x'00';
           if expCfgDta.ifsDivDir = 'Y';
             basePath =  %trimr(basePath) + %trimr(csvFolder) + '/' +
               %trimr(csvRptTyp) + '/' + csvYYYYMM + '/';
           endif;
           // Create directories if they don't exist.
           spyIFS('CRTPTH':basePath);
           // Open a handle to the CSV file.
           // Check to see if csv file exists first.
           if access(%trimr(csvPath):F_OK) <> OK;
             csvFH = open(%trimr(csvPath):O_CREAT+O_WRONLY+O_CODEPAGE+O_SYNC:
               M_RWX:819);
             callp close(csvFH);
           endif;
           clear msgRtn;
           select;
           when curObjTyp = OBJTYPRPT;
             reportDateISO =  %int(%char(%date(rpt.datfop:*cymd):*iso0));
             //        if cfgOutQ <> ' ';

             rptName = rpt.filnam;
             reset outfrm;
             reset rptud;
             in(e) lda;
             clear lda;
             out(e) lda;
             clear pdfPathRtn;
             // Paginate PDF documents.
             // if (rpt.apftyp = '3' or rpt.apftyp = '4') and cfgCvtPDF = 'Y';
             //        if cfgCvtPDF = 'Y';
             setup4output(basePath:timeKey:pdfPathRtn);
             path = pdfPathRtn;
             rptName = '*DTAQ';
             // Following two fields used as key to dtaq. job#/time
             outfrm = jobnbr;
             rptud = timeKey;
             //        endif;

             spg = 1;
             epg = rpt.totpag;
             if expCfgDta.expRptsAS = 'D' or rpt.apftyp = '3';
               spg = rpt.spg;
               epg = rpt.epg;
             endif;

             pdfPathRtn = %trimr(pdfPathRtn) + x'00';
             if expCfgDta.expRptsAS = 'R' and
               access(%trimr(pdfPathRtn):F_OK) <> OK or
               expCfgDta.expRptsAS = 'D';
               print2038(rptName:outfrm:rptud:spg:epg:cfgOutq:
                 cfgOutqLib:printFile:printFileLib:1:999:1:' ':' ':
                 ' ':RPT.REPLOC:rpt.ofrnam:0:247:81:RPT.LOCSFA:RPT.LOCSFD:
                 RPT.LOCSFP:'N':RPT.FLDR:RPT.FLDRLB:RPT.REPIND:' ':'*NONE':
                 '*ORG':'*AUTO':' ':' ':'*SYSDFT':'*SYSDFT':'*ORG':'N');
               if rpt.filnam <> rptName;
                 rpt.filnam = rptName;
               endif;
               if %subst(rpt.filnam:1:1) >= '0' and
                 %subst(rpt.filnam:1:1) <= '9';
                 %subst(rpt.filnam:1:1) = 'X';
               endif;
             endif;

             select;
             when msg.ID <> ' ';
               fmtMsg(' ':PSCON:msg:msgRtn);
             when rcvLstMsg(msgRtn) = OK;
             endsl;
             if msgRtn <> ' ';
               %subst(rpt.repind:1:1) = 'E';
             else;
               msgRtn = 'Exported';
             endif;
             if cfgCvtPDF <> 'Y' and rpt.apftyp <> '4' and rpt.apftyp <> '3'
               and cfgOutQ <> ' ';
               run('CHGSPLFA FILE(' + %trimr(rpt.filnam) + ') SPLNBR(*LAST) ' +
                 'USRDFNDTA(' + SQ + '&DATFOP="' + %char(reportDateISO) +  '"' +
                                        ',&TIMFOP="' + %char(rpt.timfop) + '"' +
                                        ',&ID="' + rpt.repind + '"' + SQ + ')' +
                                     ' USRDFNOPT(' + %trimr(rpt.pgmopf) + ')');
             endif;

             rc = exportReport();

             writeLog(rpt.fldr:rpt.rpttyp:rpt.repind:rpt.lxseq:reportDateISO:
             msgRtn:links);
             exportNotes(rpt.repind:rpt.spg);
           when curObjTyp = OBJTYPIMG;
             if writeImages() <> OK;
               %subst(img.idbnum:1:1) = 'E';
               writeLog(img.idfld:img.idrtyp:img.idbnum:img.lxseq:img.iddscn:
                 msgRtn:links);
             else;
               msgRtn = 'Exported';
               writeLog(img.idfld:img.idrtyp:img.idbnum:img.lxseq:img.iddscn:
                 msgRtn:links);
               exportNotes(img.idbnum:img.spg);
             endif;
           endsl;

           doFetch(curObjTyp);

         enddo;

       //*  exec sql
       //*    close c1;
     C                   Z-ADD     12            SQLER6                         SQL
     C     SQL_00010     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00008                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00008                      SQL
     C                   END                                                    SQL

         if curObjTyp = OBJTYPIMG;
           // Close the handle to the CSV.
           callp close(csvFH);
           // Shutdown mag1092.
           getImageData('CLOSEW');
         endif;
         formatNdxFile();

       endsr; //ProcessType

       //***********************************************************************
       begsr quit;

         if expcfgdta.expNotes = 'Y';

           path = %trimr(cfgdir) + '/Annotations.CSV';

           // Write note header if flag to write headers is on.
           if expCfgDta.addHdrRcd = 'Y';
             if access(%trimr(path):F_OK) <> OK;
               csvNoteFH = open(%trimr(path):O_CREAT+O_WRONLY+O_CODEPAGE+O_SYNC:
                 M_RWX:819);
               callp close(csvNoteFH);
               csvNoteFH = open(%trimr(path):O_WRONLY+O_TEXTDATA+
                 O_APPEND+O_SYNC);
               clear noteData;
               for i = 1 to %elem(csvHeaderA);
                 noteData = %trimr(noteData) +
                   strDlm + %trimr(csvHeaderA(i)) + strdlm;
                 if i < %elem(csvHeaderA);
                   noteData = %trimr(noteData) + fldDlm;
                 endif;
               endfor;
               noteData = %trimr(noteData) + CRLF;
               callp write(csvNoteFH:%addr(noteData):%len(%trim(noteData)));
               callp close(csvNoteFH);
             endif;
           endif;

           run('cpytoimpf fromfile(qtemp/expnotes) ' +
             'tostmf(' + sq + %trimr(path) + sq +
             ') rcddlm(*crlf) rmvblank(*both) mbropt(*add) ' +
             'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
             sq + %trim(fldDlm) + sq + ')' );
         endif;

         run('DLCOBJ OBJ((EXPORT *PGM *EXCL)) SCOPE(*JOB)');

         *inlr = '1';

         return;

       endsr;
      /end-free

       //***********************************************************************
     p bldStmt         b
     d                 pi
     d statementType                  1    const
     d textStmt        s           1024
      /free

     D                 DS                  STATIC                               CLOSE
     D  SQL_00014              1      2B 0 INZ(128)                             length of header
     D  SQL_00015              3      4B 0 INZ(13)                              statement number
     D  SQL_00016              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00017              9      9A   INZ('0')                             data is okay
     D  SQL_00018             10    127A                                        end of header
     D  SQL_00019            128    128A                                        end of header
     D  SQCALL000014   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00020              1      2B 0 INZ(128)                             length of header
     D  SQL_00021              3      4B 0 INZ(15)                              statement number
     D  SQL_00022              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00023              9      9A   INZ('0')                             data is okay
     D  SQL_00024             10    127A                                        end of header
     D  SQL_00025            128    128A                                        end of header
     D                 DS                  STATIC                               CLOSE
     D  SQL_00026              1      2B 0 INZ(128)                             length of header
     D  SQL_00027              3      4B 0 INZ(16)                              statement number
     D  SQL_00028              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00029              9      9A   INZ('0')                             data is okay
     D  SQL_00030             10    127A                                        end of header
     D  SQL_00031            128    128A                                        end of header
     D  SQCALL000017   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00032              1      2B 0 INZ(128)                             length of header
     D  SQL_00033              3      4B 0 INZ(18)                              statement number
     D  SQL_00034              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00035              9      9A   INZ('0')                             data is okay
     D  SQL_00036             10    127A                                        end of header
     D  SQL_00037            128    128A                                        end of header
     D                 DS                  STATIC                               CLOSE
     D  SQL_00038              1      2B 0 INZ(128)                             length of header
     D  SQL_00039              3      4B 0 INZ(19)                              statement number
     D  SQL_00040              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00041              9      9A   INZ('0')                             data is okay
     D  SQL_00042             10    127A                                        end of header
     D  SQL_00043            128    128A                                        end of header
     D  SQCALL000020   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00044              1      2B 0 INZ(128)                             length of header
     D  SQL_00045              3      4B 0 INZ(21)                              statement number
     D  SQL_00046              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00047              9      9A   INZ('0')                             data is okay
     D  SQL_00048             10    127A                                        end of header
     D  SQL_00049            128    128A                                        end of header
     D  SQCALL000022   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00050              1      2B 0 INZ(128)                             length of header
     D  SQL_00051              3      4B 0 INZ(23)                              statement number
     D  SQL_00052              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00053              9      9A   INZ('0')                             data is okay
     D  SQL_00054             10    127A                                        end of header
     D  SQL_00055            128    128A                                        end of header
       if statementType = BS_LINK or statementType = OBJTYPRPT or
         statementType = OBJTYPIMG;
         if exportByCSV;
           run('ovrdbf aLinkFile QTEMP/CSVINPUT ovrscope(*job)');
         else;
           getLnkDef(cfgType);
           run('ovrdbf aLinkFile ' + linkDef.lnkfil + ' ovrscope(*job)');
         endif;
       endif;

       select;
       when statementType = OBJTYPRPT;
         textStmt = 'select fldr,fldrlb,filnam,jobnam,usrnam,jobnum,filnum,' +
           'frmtyp,usrdta,datfop,timfop,devcls,ovrlin,prtfon,pagrot,maxsiz,' +
           'adsf,expdat,pgmopf,repind,totpag,lpi,cpi,' +
           'locsfa,locsfd,locsfp,reploc,ofrnam,apftyp,mdatop,mtimop,rpttyp';
         if expCfgDta.rptNdxFmt = 'I';
           textStmt = %trimr(textStmt) +
            ',ldxnam,' +
            'lxseq,lxspg,lxepg,lxiv1,lxiv2,lxiv3,lxiv4,lxiv5,lxiv6,lxiv7,' +
            'lxiv8';
         endif;
         textStmt = %trimr(textStmt) + ' from mrptdir ';
         if expCfgDta.rptNdxFmt = 'I';
           textStmt = %trimr(textStmt) +
             ' join aLinkFile on ldxnam = repind ';
         endif;
         textStmt = %trimr(textStmt) +
         ' exception join explog on logObjID = repind';
         if expCfgDta.rptNdxFmt = 'I';
           textStmt = %trimr(textStmt) +
             ' and logseqnum = lxseq';
         endif;
         textStmt = %trimr(textStmt) + ' where';
         if %subst(cfgType:1:4) <> '*ALL';
           textStmt = %trimr(textStmt) + ' rpttyp = ' + sq +
           %trimr(cfgType) + sq +  ' and';
         endif;
         if %subst(cfgFolder:1:4) <> '*ALL';
           textStmt = %trimr(textStmt) + ' fldr = ' + sq +
             %trimr(cfgFolder) + sq +  ' and';
         endif;
         textStmt = %trimr(textStmt) + ' datfop between ' +
         %char(cfgFrDate:*cymd0) + ' and ' + %char(cfgToDate:*cymd0);
         addIndexTest(textStmt:statementType);
         textStmt = %trimr(textStmt) +
         ' order by fldr, rpttyp, reploc desc, ofrvol, datfop';
       when statementType = OBJTYPIMG;
         textStmt = 'select idrtyp,idbnum,idfld,iddscn,ldxnam,' +
           'lxseq,lxspg,lxepg,' +
           'lxiv1,lxiv2,lxiv3,lxiv4,lxiv5,lxiv6,lxiv7, ' +
           'lxiv8 from mimgdir ' +
           'join aLinkFile on ldxnam = idbnum ' +
           'left join mopttbl on optrnm = idbnum exception join explog on ' +
           'logObjID = idbnum and logSeqNum = lxseq where';
         if %subst(cfgType:1:4) <> '*ALL';
           textStmt = %trimr(textStmt) + ' mimgdir.idrtyp = ' +
             sq + %trimr(cfgType) + sq + ' and';
         endif;
         if %subst(cfgFolder:1:4) <> '*ALL';
           textStmt = %trimr(textStmt) + ' idfld = ' + sq +
           %trimr(cfgFolder) + sq +  ' and';
         endif;
         textStmt = %trimr(textStmt) + ' iddscn between ' +
         %char(cfgFrDate:*iso0) + ' and ' + %char(cfgToDate:*iso0);
         addIndexTest(textStmt:statementType);
         textStmt = %trimr(textStmt) +
         ' order by idfld, idrtyp, idiloc desc,optvol, iddcpt ' +
         ' for read only ';
       when statementType = BS_LINK;
         textStmt ='select ldxnam,lxseq,lxspg,lxepg,lxiv1,lxiv2,lxiv3,lxiv4,'+
           'lxiv5,lxiv6,lxiv7,lxiv8 from aLinkFile where ldxnam = ';
         if curObjTyp = OBJTYPRPT;
           textStmt = %trimr(textStmt) + SQ + rpt.repind + SQ;
         else;
           textStmt = %trimr(textStmt) + SQ + img.idbnum + SQ;
         endif;
       when statementType = BS_DEDUP;
         textStmt = 'select * from ' + wrkFile +
           ' order by id,seqnbr,filepath' +
           ' for update of archiveType, createDate';
       when statementType = BS_NATPDF; // Native PDF binary data from A file.
         textStmt = 'select apfdta from ' + apfFile + ' where apfrep = ' +
           sq + rpt.repind + sq + ' order by apfrep, apfseq';
       endsl;

       select;
       when statementType = BS_NATPDF;
       //*  exec sql
       //*    close c6;
     C                   Z-ADD     13            SQLER6                         SQL
     C     SQL_00016     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00014                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00014                      SQL
     C                   END                                                    SQL
       //*  exec sql
       //*    prepare sqlstmt6 from :textstmt;
          SQLER6 = 14;                                                          //SQL
          SQCALL000014(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*  exec sql
       //*    declare c6 cursor for sqlstmt6;
       //*  exec sql
       //*    open c6;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00022     IFEQ      0                                            SQL
     C     SQL_00023     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00020                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00020                      SQL
     C                   END                                                    SQL
       when statementType = BS_DEDUP;
       //*  exec sql
       //*    close c3;
     C                   Z-ADD     16            SQLER6                         SQL
     C     SQL_00028     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00026                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00026                      SQL
     C                   END                                                    SQL
       //*  exec sql
       //*    prepare sqlstmt3 from :textstmt;
          SQLER6 = 17;                                                          //SQL
          SQCALL000017(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*  exec sql
       //*    declare c3 cursor for sqlstmt3;
       //*  exec sql
       //*    open c3;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00034     IFEQ      0                                            SQL
     C     SQL_00035     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00032                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00032                      SQL
     C                   END                                                    SQL
       when statementType = BS_LINK;
       //*  exec sql
       //*    close c2;
     C                   Z-ADD     19            SQLER6                         SQL
     C     SQL_00040     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00038                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00038                      SQL
     C                   END                                                    SQL
       //*  exec sql
       //*    prepare sqlstmt2 from :textstmt;
          SQLER6 = 20;                                                          //SQL
          SQCALL000020(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*  exec sql
       //*    declare c2 cursor for sqlstmt2;
       //*  exec sql
       //*    open c2;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00046     IFEQ      0                                            SQL
     C     SQL_00047     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00044                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00044                      SQL
     C                   END                                                    SQL
       other;
       //*  exec sql
       //*    prepare sqlstmt from :textstmt;
          SQLER6 = 22;                                                          //SQL
          SQCALL000022(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*  exec sql
       //*    declare c1 cursor for sqlstmt;
       //*  exec sql
       //*    open c1;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00052     IFEQ      0                                            SQL
     C     SQL_00053     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00050                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00050                      SQL
     C                   END                                                    SQL
       endsl;

       return;

      /end-free
     p                 e
       //***********************************************************************
     p rcvLstMsg       b
     d                 pi            10i 0
     d msgRtn                        80
      *copy qsysinc/qrpglesrc,qmhrcvm
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QMHRCVM
     D*
     D*Descriptive Name: Receive Nonprogram Message.
     D*
     D*5763-SS1  (C) Copyright IBM Corp. 1994,1994
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*
     D*Description: The Receive Nonprogram Message API receives a
     D*          message from a nonprogram message queue.
     D*
     D*Header Files Included:
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qmh_Rcvm_RCVM0100_t
     D*             Qmh_Rcvm_RCVM0200_t
     D*
     D*Function Prototype List: QMHRCVM
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*$A0= D2862000     3D10  940424 RGARVEY : New Include
     D*$A1= D98871     v5r2m0  010902 LIGGETT:  Add microseconds
     D*$A2= D99526     v5r3m0  030131 LIGGETT:  Add user name
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS ******************************
     D*****************************************************************
     D*Prototype for calling Message Handler API QMHRCVM
     D*****************************************************************
     D QMHRCVM         C                   'QMHRCVM'
     D*****************************************************************
     D*Type Definition for the RCVM0100 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM010000       DS
     D*                                             Qmh Rcvm RCVM0100
     D QMHBRTN                 1      4B 0
     D*                                             Bytes Returned
     D QMHBAVL00               5      8B 0
     D*                                             Bytes Available
     D QMHMS03                 9     12B 0
     D*                                             Message Severity
     D QMHMI01                13     19
     D*                                             Message Id
     D QMHMT01                20     21
     D*                                             Message Type
     D QMHMK01                22     25
     D*                                             Message Key
     D QMHERVED10             26     32
     D*                                             Reserved
     D QMHSIDCS               33     36B 0
     D*                                             CCSID Convert Status
     D QMHCSIDR               37     40B 0
     D*                                             CCSID Returned
     D QMHDRTN                41     44B 0
     D*                                             Data Returned
     D QMHDAVL                45     48B 0
     D*                                             Data Available
     D*QMHMD                  49     49
     D*
     D*                             Varying length
     D*****************************************************************
     D*Type Definition for the RCVM0200 format.
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Any varying length field will
     D*   have to be defined by the user.
     D*****************************************************************
     DQMHM0200         DS
     D*                                             Qmh Rcvm RCVM0200
     D QMHBRTN00               1      4B 0
     D*                                             Bytes Returned
     D QMHBAVL01               5      8B 0
     D*                                             Bytes Available
     D QMHMS04                 9     12B 0
     D*                                             Message Severity
     D QMHMI02                13     19
     D*                                             Message Id
     D QMHMT02                20     21
     D*                                             Message Type
     D QMHMK02                22     25
     D*                                             Message Key
     D QMHMFILN01             26     35
     D*                                             Message File Name
     D QMHMFILL               36     45
     D*                                             Message File Library
     D QMHMLIBU               46     55
     D*                                             Message Library Used
     D QMHSJ                  56     65
     D*                                             Send Job
     D QMHSUP                 66     75
     D*                                   User name from qualified
     D*                                   job name.            @A2C
     D QMHSJNBR               76     81
     D*                                             Send Job Number
     D QMHSPGMN               82     93
     D*                                             Send Program Name
     D QMHRSV100              94     97
     D*                                             Reserved1
     D QMHSD03                98    104
     D*                                             Send Date
     D QMHST01               105    110
     D*                                             Send Time
     D QMHSTM01              111    116
     D*                                             Send Time Microseconds
     D*                                                        @A1A
     D QMHSUN                117    126
     D*                                  Actual sending user.  @A2A
     D QMHRSV207             127    127
     D*                                             Reserved2
     D*                                                        @A2C
     D QMHSIDCS00            128    131B 0
     D*                                             Text CCSID Convert Status
     D QMHSIDCS01            132    135B 0
     D*                                             Data CCSID Convert Status
     D QMHAO                 136    144
     D*                                             Alert Option
     D QMHCSIDR00            145    148B 0
     D*                                             Text CCSID Returned
     D QMHCSIDR01            149    152B 0
     D*                                             Data CCSID Returned
     D QMHLDRTN              153    156B 0
     D*                                             Length Data Returned
     D QMHLDAVL              157    160B 0
     D*                                             Length Data Available
     D QMHLMRTN              161    164B 0
     D*                                             Length Message Returned
     D QMHLMAVL              165    168B 0
     D*                                             Length Message Available
     D QMHLHRTN              169    172B 0
     D*                                             Length Help Returned
     D QMHLHAVL              173    176B 0
     D*                                             Length Help Available
     D*QMHMT03               177    177
     D*
     D*                             Varying length
     D*QMHSSAGE              178    178
     D*
     D*                             Varying length
     D*QMHMH                 179    179
     D*
     D*                             Varying length

      *copy qsysinc/qrpglesrc,qusec
     D*** START HEADER FILE SPECIFICATIONS ****************************
     D*
     D*Header File Name: H/QUSEC
     D*
     D*Descriptive Name: Error Code Parameter.
     D*
     D*5763-SS1, 5722-SS1 (C) Copyright IBM Corp. 1994, 2001.
     D*All rights reserved.
     D*US Government Users Restricted Rights -
     D*Use, duplication or disclosure restricted
     D*by GSA ADP Schedule Contract with IBM Corp.
     D*
     D*Licensed Materials-Property of IBM
     D*
     D*
     D*Description: Include header file for the error code parameter.
     D*
     D*Header Files Included: None.
     D*
     D*Macros List: None.
     D*
     D*Structure List: Qus_EC_t
     D*             Qus_ERRC0200_t
     D*
     D*Function Prototype List: None.
     D*
     D*Change Activity:
     D*
     D*CFD List:
     D*
     D*FLAG REASON       LEVEL DATE   PGMR      CHANGE DESCRIPTION
     D*---- ------------ ----- ------ --------- ----------------------
     D*
     D*End CFD List.
     D*
     D*Additional notes about the Change Activity
     D*End Change Activity.
     D*** END HEADER FILE SPECIFICATIONS ******************************
     D*****************************************************************
     D*Record structure for Error Code Parameter
     D****                                                          ***
     D*NOTE: The following type definition only defines the fixed
     D*   portion of the format.  Varying length field Exception
     D*   Data will not be defined here.
     D*****************************************************************
     DQUSEC            DS
     D*                                             Qus EC
     D QUSBPRV                 1      4B 0
     D*                                             Bytes Provided
     D QUSBAVL                 5      8B 0
     D*                                             Bytes Available
     D QUSEI                   9     15
     D*                                             Exception Id
     D QUSERVED               16     16
     D*                                             Reserved
     D*QUSED01                17     17
     D*
     D*                                      Varying length
     DQUSC0200         DS
     D*                                             Qus ERRC0200
     D QUSK01                  1      4B 0
     D*                                             Key
     D QUSBPRV00               5      8B 0
     D*                                             Bytes Provided
     D QUSBAVL14               9     12B 0
     D*                                             Bytes Available
     D QUSEI00                13     19
     D*                                             Exception Id
     D QUSERVED39             20     20
     D*                                             Reserved
     D QUSCCSID11             21     24B 0
     D*                                             CCSID
     D QUSOED01               25     28B 0
     D*                                             Offset Exc Data
     D QUSLED01               29     32B 0
     D*                                             Length Exc Data
     D*QUSRSV214              33     33
     D*                                             Reserved2
     D*
     D*QUSED02                34     34
     D*
     D*                                      Varying Length    @B1A

     d rcvMsg          pr                  extpgm('QMHRCVM')
     d  receiver                           likeds(rcvr)
     d  len                          10i 0 const
     d  format                        8    const
     d  msgQ                         20    const
     d  msgType                      10    const
     d  msgKey                        4    const
     d  waitTime                     10i 0 const
     d  msgAction                    10    const
     d  errorCode                          likeds(qusec)
     d rcvr            ds                  qualified
     d  r                                  likeds(QMHM0200)
     d  msg                         100
     d SYSOPRMSGQ      c                   'QSYSOPR   QSYS      '
      /free
       clear qusec;
       qusbprv = %size(qusec);
       rcvMsg(rcvr:%size(rcvr):'RCVM0200':SYSOPRMSGQ:'*LAST':' ':0:
         '*SAME':qusec);
       if qusbavl = 0;
         if rcvr.r.QMHSJ = jobNam and rcvr.r.QMHSUP = user and
           rcvr.r.QMHSJNBR = jobNbr;
           rcvMsg(rcvr:%size(rcvr):'RCVM0200':SYSOPRMSGQ:'*INFO':rcvr.r.QMHMK02:
             0:'*REMOVE':qusec);
           msgRtn = rcvr.msg;
           return OK;
         endif;
       endif;
       return -1;
      /end-free
     p                 e

       //***********************************************************************
     p doFetch         b
     d                 pi
     d type                           1    const
      /free

     D                 DS                  STATIC                               FETCH
     D  SQL_00056              1      2B 0 INZ(128)                             length of header
     D  SQL_00057              3      4B 0 INZ(24)                              statement number
     D  SQL_00058              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00059              9      9A   INZ('0')                             data is okay
     D  SQL_00060             10    127A                                        end of header
     D  SQL_00061            129    138A                                        RPT.FLDR
     D  SQL_00062            139    148A                                        RPT.FLDRLB
     D  SQL_00063            149    158A                                        RPT.FILNAM
     D  SQL_00064            159    168A                                        RPT.JOBNAM
     D  SQL_00065            169    178A                                        RPT.USRNAM
     D  SQL_00066            179    184A                                        RPT.JOBNUM
     D  SQL_00067            185    188I 0                                      RPT.FILNUM
     D  SQL_00068            189    198A                                        RPT.FRMTYP
     D  SQL_00069            199    208A                                        RPT.USRDTA
     D  SQL_00070            209    212I 0                                      RPT.DATFOP
     D  SQL_00071            213    216I 0                                      RPT.TIMFOP
     D  SQL_00072            217    226A                                        RPT.DEVCLS
     D  SQL_00073            227    231P 0                                      RPT.OVRLIN
     D  SQL_00074            232    241A                                        RPT.PRTFON
     D  SQL_00075            242    246P 0                                      RPT.PAGROT
     D  SQL_00076            247    251P 0                                      RPT.MAXSIZ
     D  SQL_00077            252    256P 0                                      RPT.ADSF
     D  SQL_00078            257    261P 0                                      RPT.EXPDAT
     D  SQL_00079            262    271A                                        RPT.PGMOPF
     D  SQL_00080            272    281A                                        RPT.REPIND
     D  SQL_00081            282    286P 0                                      RPT.TOTPAG
     D  SQL_00082            287    291P 0                                      RPT.LPI
     D  SQL_00083            292    296P 0                                      RPT.CPI
     D  SQL_00084            297    301P 0                                      RPT.LOCSFA
     D  SQL_00085            302    306P 0                                      RPT.LOCSFD
     D  SQL_00086            307    311P 0                                      RPT.LOCSFP
     D  SQL_00087            312    312A                                        RPT.REPLOC
     D  SQL_00088            313    322A                                        RPT.OFRNAM
     D  SQL_00089            323    323A                                        RPT.APFTYP
     D  SQL_00090            324    328P 0                                      RPT.MDATOP
     D  SQL_00091            329    333P 0                                      RPT.MTIMOP
     D  SQL_00092            334    343A                                        RPT.RPTTYP
     D  SQL_00093            344    353A                                        RPT.LDXNAM
     D  SQL_00094            354    358P 0                                      RPT.LXSEQ
     D  SQL_00095            359    363P 0                                      RPT.SPG
     D  SQL_00096            364    368P 0                                      RPT.EPG
     D  SQL_00097            369    467A                                        RPT.LXIV1
     D  SQL_00098            468    566A                                        RPT.LXIV2
     D  SQL_00099            567    665A                                        RPT.LXIV3
     D  SQL_00100            666    764A                                        RPT.LXIV4
     D  SQL_00101            765    863A                                        RPT.LXIV5
     D  SQL_00102            864    962A                                        RPT.LXIV6
     D  SQL_00103            963   1061A                                        RPT.LXIV7
     D  SQL_00104           1062   1069A                                        RPT.LXIV8
     D                 DS                  STATIC                               FETCH
     D  SQL_00105              1      2B 0 INZ(128)                             length of header
     D  SQL_00106              3      4B 0 INZ(25)                              statement number
     D  SQL_00107              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00108              9      9A   INZ('0')                             data is okay
     D  SQL_00109             10    127A                                        end of header
     D  SQL_00110            129    138A                                        IMG.IDRTYP
     D  SQL_00111            139    148A                                        IMG.IDBNUM
     D  SQL_00112            149    158A                                        IMG.IDFLD
     D  SQL_00113            159    162I 0                                      IMG.IDDSCN
     D  SQL_00114            163    172A                                        IMG.LDXNAM
     D  SQL_00115            173    177P 0                                      IMG.LXSEQ
     D  SQL_00116            178    182P 0                                      IMG.SPG
     D  SQL_00117            183    187P 0                                      IMG.EPG
     D  SQL_00118            188    286A                                        IMG.LXIV1
     D  SQL_00119            287    385A                                        IMG.LXIV2
     D  SQL_00120            386    484A                                        IMG.LXIV3
     D  SQL_00121            485    583A                                        IMG.LXIV4
     D  SQL_00122            584    682A                                        IMG.LXIV5
     D  SQL_00123            683    781A                                        IMG.LXIV6
     D  SQL_00124            782    880A                                        IMG.LXIV7
     D  SQL_00125            881    888A                                        IMG.LXIV8
     D                 DS                  STATIC                               FETCH
     D  SQL_00126              1      2B 0 INZ(128)                             length of header
     D  SQL_00127              3      4B 0 INZ(26)                              statement number
     D  SQL_00128              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00129              9      9A   INZ('0')                             data is okay
     D  SQL_00130             10    127A                                        end of header
     D  SQL_00131            129    138A                                        LINKS.ID
     D  SQL_00132            139    143P 0                                      LINKS.SEQ
     D  SQL_00133            144    148P 0                                      LINKS.SPG
     D  SQL_00134            149    153P 0                                      LINKS.EPG
     D  SQL_00135            154    252A                                        LINKS.NDX1
     D  SQL_00136            253    351A                                        LINKS.NDX2
     D  SQL_00137            352    450A                                        LINKS.NDX3
     D  SQL_00138            451    549A                                        LINKS.NDX4
     D  SQL_00139            550    648A                                        LINKS.NDX5
     D  SQL_00140            649    747A                                        LINKS.NDX6
     D  SQL_00141            748    846A                                        LINKS.NDX7
     D  SQL_00142            847    854A                                        LINKS.DATE
     D                 DS                  STATIC                               FETCH
     D  SQL_00143              1      2B 0 INZ(128)                             length of header
     D  SQL_00144              3      4B 0 INZ(27)                              statement number
     D  SQL_00145              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00146              9      9A   INZ('0')                             data is okay
     D  SQL_00147             10    127A                                        end of header
     D  SQL_00148            129    384A                                        WRKNDXRCD.PATH
     D  SQL_00149            385    399A                                        WRKNDXRCD.CLASS
     D  SQL_00150            400    409A                                        WRKNDXRCD.ARCHTYPE
     D  SQL_00151            410    424A                                        WRKNDXRCD.ID
     D  SQL_00152            425    434A                                        WRKNDXRCD.SEQNBR
     D  SQL_00153            435    439A                                        WRKNDXRCD.BLANK
     D  SQL_00154            440    454A                                        WRKNDXRCD.CREATEDATE
     D  SQL_00155            455    524A                                        WRKNDXRCD.NDX1
     D  SQL_00156            525    594A                                        WRKNDXRCD.NDX2
     D  SQL_00157            595    664A                                        WRKNDXRCD.NDX3
     D  SQL_00158            665    734A                                        WRKNDXRCD.NDX4
     D  SQL_00159            735    804A                                        WRKNDXRCD.NDX5
     D  SQL_00160            805    874A                                        WRKNDXRCD.NDX6
     D  SQL_00161            875    944A                                        WRKNDXRCD.NDX7
     D                 DS                  STATIC                               FETCH
     D  SQL_00162              1      2B 0 INZ(128)                             length of header
     D  SQL_00163              3      4B 0 INZ(28)                              statement number
     D  SQL_00164              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00165              9      9A   INZ('0')                             data is okay
     D  SQL_00166             10    127A                                        end of header
     D  SQL_00167            129   4207A                                        APFDTA
       select;
       when type = OBJTYPRPT;
       //*  exec sql
       //*    fetch c1
       //*      into :rpt;
     C                   Z-ADD     -4            SQLER6                         SQL   24
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00056                      SQL
     C     SQL_00059     IFEQ      '1'                                          SQL
     C                   EVAL      RPT.FLDR = SQL_00061                         SQL
     C                   EVAL      RPT.FLDRLB = SQL_00062                       SQL
     C                   EVAL      RPT.FILNAM = SQL_00063                       SQL
     C                   EVAL      RPT.JOBNAM = SQL_00064                       SQL
     C                   EVAL      RPT.USRNAM = SQL_00065                       SQL
     C                   EVAL      RPT.JOBNUM = SQL_00066                       SQL
     C                   EVAL      RPT.FILNUM = SQL_00067                       SQL
     C                   EVAL      RPT.FRMTYP = SQL_00068                       SQL
     C                   EVAL      RPT.USRDTA = SQL_00069                       SQL
     C                   EVAL      RPT.DATFOP = SQL_00070                       SQL
     C                   EVAL      RPT.TIMFOP = SQL_00071                       SQL
     C                   EVAL      RPT.DEVCLS = SQL_00072                       SQL
     C                   EVAL      RPT.OVRLIN = SQL_00073                       SQL
     C                   EVAL      RPT.PRTFON = SQL_00074                       SQL
     C                   EVAL      RPT.PAGROT = SQL_00075                       SQL
     C                   EVAL      RPT.MAXSIZ = SQL_00076                       SQL
     C                   EVAL      RPT.ADSF = SQL_00077                         SQL
     C                   EVAL      RPT.EXPDAT = SQL_00078                       SQL
     C                   EVAL      RPT.PGMOPF = SQL_00079                       SQL
     C                   EVAL      RPT.REPIND = SQL_00080                       SQL
     C                   EVAL      RPT.TOTPAG = SQL_00081                       SQL
     C                   EVAL      RPT.LPI = SQL_00082                          SQL
     C                   EVAL      RPT.CPI = SQL_00083                          SQL
     C                   EVAL      RPT.LOCSFA = SQL_00084                       SQL
     C                   EVAL      RPT.LOCSFD = SQL_00085                       SQL
     C                   EVAL      RPT.LOCSFP = SQL_00086                       SQL
     C                   EVAL      RPT.REPLOC = SQL_00087                       SQL
     C                   EVAL      RPT.OFRNAM = SQL_00088                       SQL
     C                   EVAL      RPT.APFTYP = SQL_00089                       SQL
     C                   EVAL      RPT.MDATOP = SQL_00090                       SQL
     C                   EVAL      RPT.MTIMOP = SQL_00091                       SQL
     C                   EVAL      RPT.RPTTYP = SQL_00092                       SQL
     C                   EVAL      RPT.LDXNAM = SQL_00093                       SQL
     C                   EVAL      RPT.LXSEQ = SQL_00094                        SQL
     C                   EVAL      RPT.SPG = SQL_00095                          SQL
     C                   EVAL      RPT.EPG = SQL_00096                          SQL
     C                   EVAL      RPT.LXIV1 = SQL_00097                        SQL
     C                   EVAL      RPT.LXIV2 = SQL_00098                        SQL
     C                   EVAL      RPT.LXIV3 = SQL_00099                        SQL
     C                   EVAL      RPT.LXIV4 = SQL_00100                        SQL
     C                   EVAL      RPT.LXIV5 = SQL_00101                        SQL
     C                   EVAL      RPT.LXIV6 = SQL_00102                        SQL
     C                   EVAL      RPT.LXIV7 = SQL_00103                        SQL
     C                   EVAL      RPT.LXIV8 = SQL_00104                        SQL
     C                   END                                                    SQL
       when type = OBJTYPIMG;
       //*  exec sql
       //*    fetch c1
       //*      into :img;
     C                   Z-ADD     -4            SQLER6                         SQL   25
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00105                      SQL
     C     SQL_00108     IFEQ      '1'                                          SQL
     C                   EVAL      IMG.IDRTYP = SQL_00110                       SQL
     C                   EVAL      IMG.IDBNUM = SQL_00111                       SQL
     C                   EVAL      IMG.IDFLD = SQL_00112                        SQL
     C                   EVAL      IMG.IDDSCN = SQL_00113                       SQL
     C                   EVAL      IMG.LDXNAM = SQL_00114                       SQL
     C                   EVAL      IMG.LXSEQ = SQL_00115                        SQL
     C                   EVAL      IMG.SPG = SQL_00116                          SQL
     C                   EVAL      IMG.EPG = SQL_00117                          SQL
     C                   EVAL      IMG.LXIV1 = SQL_00118                        SQL
     C                   EVAL      IMG.LXIV2 = SQL_00119                        SQL
     C                   EVAL      IMG.LXIV3 = SQL_00120                        SQL
     C                   EVAL      IMG.LXIV4 = SQL_00121                        SQL
     C                   EVAL      IMG.LXIV5 = SQL_00122                        SQL
     C                   EVAL      IMG.LXIV6 = SQL_00123                        SQL
     C                   EVAL      IMG.LXIV7 = SQL_00124                        SQL
     C                   EVAL      IMG.LXIV8 = SQL_00125                        SQL
     C                   END                                                    SQL
       when type = BS_LINK;
         clear links;
       //*  exec sql
       //*    fetch c2
       //*      into :links;
     C                   Z-ADD     -4            SQLER6                         SQL   26
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00126                      SQL
     C     SQL_00129     IFEQ      '1'                                          SQL
     C                   EVAL      LINKS.ID = SQL_00131                         SQL
     C                   EVAL      LINKS.SEQ = SQL_00132                        SQL
     C                   EVAL      LINKS.SPG = SQL_00133                        SQL
     C                   EVAL      LINKS.EPG = SQL_00134                        SQL
     C                   EVAL      LINKS.NDX1 = SQL_00135                       SQL
     C                   EVAL      LINKS.NDX2 = SQL_00136                       SQL
     C                   EVAL      LINKS.NDX3 = SQL_00137                       SQL
     C                   EVAL      LINKS.NDX4 = SQL_00138                       SQL
     C                   EVAL      LINKS.NDX5 = SQL_00139                       SQL
     C                   EVAL      LINKS.NDX6 = SQL_00140                       SQL
     C                   EVAL      LINKS.NDX7 = SQL_00141                       SQL
     C                   EVAL      LINKS.DATE = SQL_00142                       SQL
     C                   END                                                    SQL
       when type = BS_DEDUP;
         clear wrkNdxRcd;
       //*  exec sql
       //*    fetch c3
       //*      into :wrkndxrcd;
     C                   Z-ADD     -4            SQLER6                         SQL   27
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00143                      SQL
     C     SQL_00146     IFEQ      '1'                                          SQL
     C                   EVAL      WRKNDXRCD.PATH = SQL_00148                   SQL
     C                   EVAL      WRKNDXRCD.CLASS = SQL_00149                  SQL
     C                   EVAL      WRKNDXRCD.ARCHTYPE = SQL_00150               SQL
     C                   EVAL      WRKNDXRCD.ID = SQL_00151                     SQL
     C                   EVAL      WRKNDXRCD.SEQNBR = SQL_00152                 SQL
     C                   EVAL      WRKNDXRCD.BLANK = SQL_00153                  SQL
     C                   EVAL      WRKNDXRCD.CREATEDATE = SQL_00154             SQL
     C                   EVAL      WRKNDXRCD.NDX1 = SQL_00155                   SQL
     C                   EVAL      WRKNDXRCD.NDX2 = SQL_00156                   SQL
     C                   EVAL      WRKNDXRCD.NDX3 = SQL_00157                   SQL
     C                   EVAL      WRKNDXRCD.NDX4 = SQL_00158                   SQL
     C                   EVAL      WRKNDXRCD.NDX5 = SQL_00159                   SQL
     C                   EVAL      WRKNDXRCD.NDX6 = SQL_00160                   SQL
     C                   EVAL      WRKNDXRCD.NDX7 = SQL_00161                   SQL
     C                   END                                                    SQL
       when type = BS_NATPDF;
       //*  exec sql
       //*    fetch c6
       //*      into :apfdta;
     C                   Z-ADD     -4            SQLER6                         SQL   28
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00162                      SQL
     C     SQL_00165     IFEQ      '1'                                          SQL
     C                   EVAL      APFDTA = SQL_00167                           SQL
     C                   END                                                    SQL
       endsl;
       return;
      /end-free
     p                 e

       //***********************************************************************
     P exportReport    B
     D                 PI            10I 0

      * Local fields
     D retField        S             10I 0 inz
     d pathBase        s            512
     d outFileName     s            128
     d cmd             s            512

     d fromPage        s             10i 0 inz
     d toPage          s             10i 0 inz
     d openOnce        s               n   inz(*off)
     d rptDesc         s             40
     d fmtType         s              4    inz('TXT')

      /FREE
       // Map links to the fetched imgdir+links structure.
       memcpy(%addr(links):%addr(rpt.ldxnam):%size(links));

       pathBase =  %trimr(cfgDir) + '/';
       if expCfgDta.ifsDivDir = 'Y';
         pathBase =  %trimr(pathBase) + %trimr(rpt.fldr) + '/' +
           %trimr(rpt.rpttyp) + '/' +
           %subst(%char(%date(rpt.datfop:*cymd):*iso0):1:6) + '/';
       endif;
       clear dts;
       rtnRec = 0;

       select;
       when expCfgDta.expRptsAS = 'D';
         fromPage = links.spg;
         toPage = links.epg;
       when expCfgDta.expRptsAS = 'R';
         fromPage = 1;
         toPage = rpt.totpag;
       endsl;

       exsr writeReportIndex;

       exsr quitSR;

       //***********************************************************************
       begsr writeReportIndex;
         // Format and write link record.
         if cfgCvtPDF = 'Y' and rpt.apftyp = '3'; //AFP
           path = pdfPathRtn;
         endif;
         fmtType = extFromPath(path);
         clear writeData;
         // Prepend OnBase file format type.
         if CFGOBTYPE <> ' ';
           writeData = %trimr(writeData) + %trim(strdlm) +
           %trim(onBaseExtVal(%lookup(fmtType:onBaseExtKey))) +%trim(strdlm)+
           %trim(flddlm);
         endif;
         if expcfgdta.nameOnly = 'Y';
           writeData = %trimr(writeData) + %trim(strdlm) +
           %trimr(fileNameFromPath(path)) + %trim(strdlm) + %trim(flddlm);
         else;
           writeData = %trimr(writeData) + %trim(strdlm) +
             %trimr(path) + %trim(strdlm) + %trim(flddlm);
         endif;
         reset fmtType;
         if cfgCvtPDF = 'Y';
           fmtType = 'PDF';
         endif;
         //  writeData = %trim(writeData) +
         //  %trim(strdlm) + %trimr(csvRptTyp) + %trim(strdlm);
         if CFGOBTYPE <> ' ';
           writeData = %trim(writeData) +
           %trim(flddlm) + %trim(strdlm) +
           %trim(onBaseExtVal(%lookup(fmtType:onBaseExtKey))) +
           %trim(strdlm);
         else;
         //    writeData = %trim(writeData) +
         //      %trim(flddlm) + %trim(strdlm) + fmtType + %trim(strdlm);
         endif;
         if expCfgDta.rptNdxFmt = 'I';
           writeData = %trim(writeData) +
           %trim(flddlm) + %trim(strdlm) + links.id + %trim(strdlm) +
           %trim(flddlm) + %trim(strdlm) + %trim(%editc(links.seq:'Z')) +
           %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(links.date) + %trim(strdlm);
           for i = 1 to %elem(ndxVals);
             writeData = %trimr(writeData) + %trim(flddlm) + %trim(ndxVals(i));
           endfor;
           writeData = %trimr(writeData) +
           %trim(flddlm) + %trim(strdlm) +
             %trim(%char(links.spg)) + %trim(strdlm) + %trim(flddlm) +
             %trim(strdlm) + %trim(%char(links.epg)) + %trim(strdlm);
         else;
           writeData = %trim(writeData) +
           %trim(strdlm) + %trim(rpt.fldr) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(rpt.fldrlb) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(rpt.filnam) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(%char(rpt.filnum))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(rpt.frmtyp) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(%char(rpt.totpag))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(%char(rpt.lpi)) +%trim(strdlm) + %trim(flddlm)+
           %trim(strdlm) + %trim(%char(rpt.cpi)) + %trim(strdlm) +%trim(flddlm)+
           %trim(strdlm) + %trim(%char(%date(rpt.datfop:*cymd):*iso0))+
             %trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(%char(%time(rpt.timfop):*hms0))+%trim(strdlm)+
             %trim(flddlm)+
           %trim(strdlm) + %trim(rpt.devcls) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(%char(rpt.ovrlin))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(rpt.prtfon) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(%char(rpt.pagrot))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(%char(rpt.maxsiz))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(%char(rpt.adsf))+%trim(strdlm) + %trim(flddlm)+
           %trim(strdlm) + %trim(%char(rpt.expdat))+%trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(rpt.repind) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(rpt.apftyp) + %trim(strdlm) + %trim(flddlm) +
           %trim(strdlm) + %trim(%char(%date(rpt.mdatop:*cymd):*iso0))+
             %trim(strdlm)+%trim(flddlm)+
           %trim(strdlm) + %trim(%char(%time(rpt.mtimop):*hms0))+%trim(strdlm)+
             %trim(flddlm)+
           %trim(strdlm) + %trim(rpt.rpttyp) + %trim(strdlm) + %trim(flddlm);
         endif;
         if CFGOBTYPE <> ' ';
           writeData = %trimr(writeData) + %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBKYWD1) + %trim(strdlm) +
           %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBKYWD2) + %trim(strdlm) +
           %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBTYPE) + %trim(strdlm);
         endif;
         writeData = %trimr(writeData) + CRLF;
         dataLen = %len(%trimr(writeData));

         dou csvFH >= 0; // Retry forever if open fails.
           csvFH = open(%trimr(csvPath):O_WRONLY+O_TEXTDATA+O_APPEND+O_SYNC);
         enddo;
         if write(csvFH:%addr(writeData):dataLen) < OK;
           msgRtn = 'Error writing to index file ' + %trimr(csvRptTyp) + '.CSV';
           callp close(csvFH);
           return -1;
         endif;
         clear writeData;
         callp close(csvFH);
       endsr;

       //*****************************
       begsr quitSR;

         spyIFS('QUIT':path:writeData:dataLen:' ':' ':msgid);
         RETURN retField;

       endsr;
      /END-FREE
     P                 E

     P*--------------------------------------------------
     P writeImages     B
     D writeImages     PI            10I 0

     D retField        S             10I 0

     d startOffSet     s              9  0 inz(0)
     d bytesRequest    s              9  0 inz(MAX_BUF)
     d cache           s              1    inz('Y')
     d imageSize       s              9  0 inz
     d bytesRtn        s              9  0 inz
     d nextRRN         s              9  0 inz
     d attrs           ds                  likeds(atrdta)
     d rtnCode         s              7
     d rtnData         s            100
     d imgDtaRtn       s                   like(imgDtaRtn_t)
     d                                     dim(%elem(imgDtaRtn_t))
     d MAX_BUF         c                   131072
     d byteCount       s             10i 0
     d i               s             10i 0
     d writeCount      s             10i 0
     d myStat          pr            10i 0 extproc('stat')
     d  path                           *   value options(*string)
     d  statusStruct                   *   value

     D mystatds        DS                  qualified
     D  st_mode                      10U 0
     D  st_ino                       10U 0
     D  st_nlink                      5U 0
     D  st_reserved2                  5U 0
     D  st_uid                       10U 0
     D  st_gid                       10U 0
     D  st_size                      10I 0
     D  st_atime                     10I 0
     D  st_mtime                     10I 0
     D  st_ctime                     10I 0
     D  st_dev                       10U 0
     D  st_blksize                   10U 0
     D  st_allocsize                 10U 0
     D  st_objtype                   11A
     D  st_reserved3                  1A
     D  st_codepage                   5U 0
     D  st_ccsid                      5U 0
     D  st_rdev                      10U 0
     D  st_nlink32                   10U 0
     D  st_rdev64                    20U 0
     D  st_dev64                     20U 0
     D  st_reserved1                 36A
     D  st_ino_gen_id                10U 0

     d filSeq          s              4s 0
     d wrkPath         s                   like(path)
     d fileExt         s              5

      /FREE

       // Map links to the fetched imgdir+links structure.
       memcpy(%addr(links):%addr(img.ldxnam):%size(links));

       // Get the image attributes.
       getImageData('GETATR':links.id:links.spg:startOffSet:bytesRequest:cache:
         imageSize:bytesRtn:nextRRN:attrs:imgDtaRtn:rtnCode:rtnData);
       if rtnCode <> ' ';
         msgRtn = rtnData;
         if msgRtn = ' ';
           msgRtn = 'Error retrieving image attributes.';
         endif;
         exsr closeImage;
         return -1;
       endif;

       // Format path and open image file.
       path = %trimr(cfgDir) + '/';
       if expCfgDta.ifsDivDir = 'Y';
         path =  %trimr(path) + %trimr(img.idfld) + '/' +
           %trimr(img.idrtyp) + '/' +
           %subst(%trim(%char(img.iddscn)):1:6) + '/';
       endif;
       clear msgid;
       spyIFS('CRTPTH':path);

       // Custom code for Cambell County
       // Increment the seq# until it doesn't exist
       // lxiv1-0001.tif. Duplicate name by index 1. TIF ONLY.
       if expCfgDta.cambellCounty = '1' and
         %trim(%subst(%xlate(lower:upper:attrs.pcext):1:3)) = 'TIF';
           filSeq = 1;
           wrkPath = %trimr(path) + %trim(links.ndx1) + '-' +
             %editc(filSeq:'X') + '.' + attrs.pcext;
           dow access(%trim(wrkPath) + x'00':F_OK) = OK;
             filSeq += 1;
             wrkPath = %trimr(path) + %trim(links.ndx1) + '-' +
               %editc(filSeq:'X') + '.' + attrs.pcext;
           enddo;
           path = wrkPath;
       else;
         path = %trimr(path) + %trim(attrs.pcfile);
         spyIFS('DUPFIL':path);
       endif;

       imageFH = open(%trimr(path):O_CREAT+O_TRUNC+O_WRONLY: M_RWX);
       if imageFH < OK;
         msgRtn = 'Error opening file for write on IFS: '+ %trim(attrs.pcfile);
         exsr closeImage;
         return EXPRPTOPN;
       endif;

       // Read image data and write to file.
       byteCount = %int(attrs.pcsize);
       dow byteCount > 0;
         if byteCount > MAX_BUF;
           bytesRequest = MAX_BUF;
         endif;
         getImageData('READ':links.id:links.spg:startOffSet:bytesRequest:cache:
         imageSize:bytesRtn:nextRRN:attrs:imgDtaRtn:rtnCode:rtnData);
         if rtnCode <> ' ';
           msgRtn = rtnData;
           if msgRtn = ' ';
             msgRtn = 'Error reading image file.';
           endif;
           exsr closeImage;
           return -1;
         endif;
         startOffSet += bytesRtn;
         if write(imageFH:%addr(imgDtaRtn):bytesRtn) < OK;
           msgRtn = 'Error writing to file on IFS: ' + attrs.pcfile;
           exsr closeImage;
           return -1;
         endif;
         byteCount -= bytesRtn;
       enddo;

       clear writeData;

       attrs.pcext = %xlate(lower:upper:attrs.pcext);

       // OnBase document type code.
       if CFGOBTYPE <> ' ';
         writeData = %trimr(writeData) + %trim(strdlm) +
         %trim(onBaseExtVal(%lookup(attrs.pcext:onBaseExtKey))) +
         %trim(strdlm) + %trim(flddlm);
       endif;

       if expcfgdta.nameOnly = 'Y';
         writeData = %trimr(writeData) + %trim(strdlm) +
         %trimr(fileNameFromPath(path)) + %trim(strdlm) + %trim(flddlm);
       else;
         writeData = %trimr(writeData) + %trim(strdlm) +
           %trimr(path) + %trim(strdlm) + %trim(flddlm);
       endif;

       writeData = %trimr(writeData) +
         %trim(strdlm) + %trimr(img.idrtyp) + %trim(strdlm) +  %trim(flddlm);
       if CFGOBTYPE <> ' ';
         writeData = %trimr(writeData) + %trim(strdlm) +
           %trim(onBaseExtVal(%lookup(attrs.pcext:onBaseExtKey))) +
           %trim(strdlm) + %trim(flddlm);
       else;
         writeData = %trimr(writeData) +
           %trim(strdlm) + %trim(attrs.pcext) + %trim(strdlm) +  %trim(flddlm);
       endif;
       writeData = %trimr(writeData) +
       %trim(strdlm) + links.id + %trim(strdlm) +  %trim(flddlm) +
       %trim(strdlm) + %trim(%editc(links.seq:'Z')) + %trim(strdlm) +
       %trim(flddlm) +
       %trim(strdlm) + %trim(strdlm) + %trim(flddlm) +
       %trim(strdlm) + %trim(links.date) + %trim(strdlm);

       for i = 1 to %elem(ndxVals);
         writeData = %trimr(writeData) + %trim(flddlm) +
           %trim(strdlm) + %trim(ndxVals(i)) + %trim(strdlm);
       endfor;

       if CFGOBTYPE <> ' ';
         writeData = %trimr(writeData) + %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBKYWD1) + %trim(strdlm) +
           %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBKYWD2) + %trim(strdlm) +
           %trim(flddlm) +
           %trim(strdlm) + %trim(CFGOBTYPE) + %trim(strdlm);
       endif;

       writeData = %trimr(writeData) + CRLF;
       dataLen = %len(%trimr(writeData));

       csvFH = open(%trimr(csvPath):O_WRONLY+O_TEXTDATA+O_APPEND+O_SYNC);
       if csvFH < OK;
         csvFH = open(%trimr(csvPath):O_WRONLY+O_TEXTDATA+O_APPEND+O_SYNC);
       endif;
       if csvFH < OK;
         p_errno = getErrno();
         msgRtn = %str(strerror(errno));
         callp close(csvFH);
         exsr closeImage;
         return -1;
       endif;
       if write(csvFH:%addr(writeData):dataLen) < OK;
         msgRtn = 'Error writing to index file ' + %trimr(img.idrtyp) + '.CSV';
         callp close(csvFH);
         exsr closeImage;
         return -1;
       endif;
       clear writeData;
       callp close(csvFH);

       exsr closeImage;

       // Verify the size of the file is what is expected.
       if mystat(%trimr(path):%addr(mystatds)) <> OK;
         msgRtn = 'Error getting file info for ' + %trim(attrs.pcfile);
         return -1;
       endif;

       // Return error if written size doesn't match archive size.
       if mystatds.st_size <> %int(%trim(attrs.pcsize));
         msgRtn = 'Size error: ' + %trim(attrs.pcfile) + ' on disk ' +
         %trim(%char(mystatds.st_size)) + ' expected ' + %trim(attrs.pcsize);
         return -1;
       endif;

       RETURN OK;

       //********************************************
       begsr closeImage;
         callp close(imageFH);
         spyIFS('QUIT');
         getImageData('CLSOPT':links.id:links.spg:startOffSet:bytesRequest:
         cache:imageSize:bytesRtn:nextRRN:attrs:imgDtaRtn:rtnCode:rtnData);

       endsr;
      /END-FREE
     P writeImages     E

      **************************************************************************
     p formatNdxFile   b
     d textStmt        s           1024
     d prvNdxRcd       ds                  likeds(wrkNdxRcd)
     d cmdStr          s           1024
     d wrkFile2        s                   like(wrkFile)
     d toStmfName      s             20
      /free
       //Create temporary index file for deduplication.

     D  SQCALL000029   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D  SQCALL000030   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  SQCALL000031   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D                 DS                  STATIC                               UPDATE
     D  SQL_00168              1      2B 0 INZ(128)                             length of header
     D  SQL_00169              3      4B 0 INZ(32)                              statement number
     D  SQL_00170              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00171              9      9A   INZ('0')                             data is okay
     D  SQL_00172             10    127A                                        end of header
     D  SQL_00173            129    143A                                        WRKNDXRCD.CREATEDATE
     D  SQL_00174            144    153A                                        WRKNDXRCD.ARCHTYPE
     D                 DS                  STATIC                               INSERT
     D  SQL_00175              1      2B 0 INZ(128)                             length of header
     D  SQL_00176              3      4B 0 INZ(33)                              statement number
     D  SQL_00177              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00178              9      9A   INZ('0')                             data is okay
     D  SQL_00179             10    127A                                        end of header
     D  SQL_00180            129    138A                                        LINKDEF.LNDXN1
     D  SQL_00181            139    148A                                        LINKDEF.LNDXN2
     D  SQL_00182            149    158A                                        LINKDEF.LNDXN3
     D  SQL_00183            159    168A                                        LINKDEF.LNDXN4
     D  SQL_00184            169    178A                                        LINKDEF.LNDXN5
     D  SQL_00185            179    188A                                        LINKDEF.LNDXN6
     D  SQL_00186            189    198A                                        LINKDEF.LNDXN7
     D                 DS                  STATIC                               INSERT
     D  SQL_00187              1      2B 0 INZ(128)                             length of header
     D  SQL_00188              3      4B 0 INZ(34)                              statement number
     D  SQL_00189              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00190              9      9A   INZ('0')                             data is okay
     D  SQL_00191             10    127A                                        end of header
     D  SQL_00192            129    138A                                        LINKDEF.LNDXN1
     D  SQL_00193            139    148A                                        LINKDEF.LNDXN2
     D  SQL_00194            149    158A                                        LINKDEF.LNDXN3
     D  SQL_00195            159    168A                                        LINKDEF.LNDXN4
     D  SQL_00196            169    178A                                        LINKDEF.LNDXN5
     D  SQL_00197            179    188A                                        LINKDEF.LNDXN6
     D  SQL_00198            189    198A                                        LINKDEF.LNDXN7
     D  SQCALL000035   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D                 DS                  STATIC                               INSERT
     D  SQL_00199              1      2B 0 INZ(128)                             length of header
     D  SQL_00200              3      4B 0 INZ(36)                              statement number
     D  SQL_00201              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00202              9      9A   INZ('0')                             data is okay
     D  SQL_00203             10    127A                                        end of header
     D  SQL_00204            129    138A                                        LINKDEF.LNDXN1
     D  SQL_00205            139    148A                                        LINKDEF.LNDXN2
     D  SQL_00206            149    158A                                        LINKDEF.LNDXN3
     D  SQL_00207            159    168A                                        LINKDEF.LNDXN4
     D  SQL_00208            169    178A                                        LINKDEF.LNDXN5
     D  SQL_00209            179    188A                                        LINKDEF.LNDXN6
     D  SQL_00210            189    198A                                        LINKDEF.LNDXN7
     D  SQCALL000037   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D  SQCALL000038   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
       wrkFile = 'X' + %subst(%char(%timestamp():*iso0):9:9);
       textStmt = 'CREATE TABLE ' + %trimr(pgmLib) + '/' + wrkFile + ' (';
       if CFGOBTYPE <> ' ';
         textStmt = %trimr(textStmt) +
         ' OBEXTCOD CHAR (15) NOT NULL WITH DEFAULT,';
       endif;
       textStmt = %trimr(textStmt) +
       ' FILEPATH CHAR (256) NOT NULL WITH DEFAULT,';
       if expcfgdta.rptNdxFmt = 'I';
         textStmt = %trimr(textstmt) + 'CLASS CHAR (' +
         ' 15) NOT NULL WITH DEFAULT, ARCHIVETYPE CHAR ( 15) NOT NULL WITH' +
         ' DEFAULT, SOMEID CHAR ( 15) NOT NULL WITH DEFAULT, SEQNBR CHAR (10)' +
         ' NOT NULL WITH DEFAULT, BLANK CHAR ( 5) NOT NULL WITH DEFAULT,' +
         ' CREATEDATE CHAR ( 15) NOT NULL WITH DEFAULT, INDEX1 CHAR ( 70) NOT' +
         ' NULL WITH DEFAULT, INDEX2 CHAR ( 70) NOT NULL WITH DEFAULT, INDEX3' +
         ' CHAR ( 70) NOT NULL WITH DEFAULT, INDEX4 CHAR ( 70) NOT NULL WITH' +
         ' DEFAULT, INDEX5 CHAR ( 70) NOT NULL WITH DEFAULT, INDEX6 CHAR (70)' +
         ' NOT NULL WITH DEFAULT, INDEX7 CHAR ( 70) NOT NULL WITH DEFAULT,' +
         ' STARTINGPAGE CHAR ( 15) NOT NULL WITH DEFAULT, ENDINGPAGE CHAR (' +
         ' 15) NOT NULL WITH DEFAULT';
       else;
         textStmt = %trimr(textstmt) +
         'FOLDER CHAR (10) NOT NULL WITH DEFAULT,' +
         'FLDLIB CHAR (10) NOT NULL WITH DEFAULT,' +
         'FILNAM CHAR (10) NOT NULL WITH DEFAULT,' +
         'FILNUM CHAR (10) NOT NULL WITH DEFAULT,' +
         'FRMTYP CHAR (10) NOT NULL WITH DEFAULT,' +
         'TOTPAG CHAR (10) NOT NULL WITH DEFAULT,' +
         'LPI CHAR (10) NOT NULL WITH DEFAULT,' +
         'CPI CHAR (10) NOT NULL WITH DEFAULT,' +
         'DATFOP CHAR (10) NOT NULL WITH DEFAULT,' +
         'TIMFOP CHAR (10) NOT NULL WITH DEFAULT,' +
         'DEVCLS CHAR (10) NOT NULL WITH DEFAULT,' +
         'OVRLIN CHAR (10) NOT NULL WITH DEFAULT,' +
         'PRTFON CHAR (10) NOT NULL WITH DEFAULT,' +
         'PAGROT CHAR (10) NOT NULL WITH DEFAULT,' +
         'MAXSIZ CHAR (10) NOT NULL WITH DEFAULT,' +
         'ADSF CHAR (10) NOT NULL WITH DEFAULT,' +
         'EXPDAT CHAR (10) NOT NULL WITH DEFAULT,' +
         'REPIND CHAR (10) NOT NULL WITH DEFAULT,' +
         'APFTYP CHAR (10) NOT NULL WITH DEFAULT,' +
         'MDATOP CHAR (10) NOT NULL WITH DEFAULT,' +
         'MTIMOP CHAR (10) NOT NULL WITH DEFAULT,' +
         'RPTTYP CHAR (10) NOT NULL WITH DEFAULT';
       endif;
       if CFGOBTYPE <> ' ';
         textStmt = %trimr(textStmt) +
           ' ,OBKYWD1 CHAR (10) NOT NULL WITH DEFAULT,' +
           ' OBKYWD2 CHAR (10) NOT NULL WITH DEFAULT,' +
           ' OBDOCTYP CHAR (15) NOT NULL WITH DEFAULT';
       endif;

       textStmt = %trimr(textStmt) + ' )';

       //*exec sql
       //*  execute immediate :textstmt;
          SQLER6 = 29;                                                          //SQL
          SQCALL000029(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL

       if expCfgDta.addHdrRcd = 'Y';
         hdrFile = 'H' + %subst(wrkFile:2:9);
         run('cpyf ' + %trimr(pgmlib) + '/' + wrkfile + ' ' +
           %trimr(pgmlib) + '/' + hdrFile + ' crtfile(*yes)');
         run('ovrdbf hdrFile ' + hdrFile + ' ovrscope(*job)');
       endif;

       run('ovrdbf wrkfile ' + wrkFile + ' ovrscope(*job)');

       // Copy the csv file into data base for manipulation.
       run('CPYFRMIMPF FROMSTMF(' + sq + %trimr(cfgDir) + '/' +
         %trim(csvRptTyp) + '.CSV' + sq + ') TOFILE( ' +
         %trimr(pgmLib) + '/' + wrkFile + ') MBROPT(*ADD) ' +
         'RCDDLM(*crLF) RMVBLANK(*BOTH) RPLNULLVAL(*FLDDFT) ' +
         'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
         sq + %trim(fldDlm) + sq + ')');

       // Delete the header record if it exists,
       //*exec sql
       //*  delete from wrkfile where class = 'DocumentClass';
          SQLER6 = 30;                                                          //SQL
          SQCALL000030(                                                         //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL

       // Read through the index file database by batch/seq/fileName order.
       // When duplicate is encountered delete the file on the IFS and
       // delete the link record. If configured, format the creation date.
       bldStmt(BS_DEDUP);
       doFetch(BS_DEDUP);
       dow sqlcod = OK;
         // If duplicate, delete stuff.
         select;
         when wrkNdxRcd.id = prvNdxRcd.id and wrkNdxRcd.seqNbr =
           prvNdxRcd.seqNbr; // Found duplicate batch/seq...delete!
       //*    exec sql
       //*      delete from wrkfile where current of c3;
          SQLER6 = 31;                                                          //SQL
          SQCALL000031(                                                         //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
           run('cd /' + %trimr(cfgdir));
           unlink(%trimr(wrkNdxRcd.path));
         other;
           exsr setCrtDate;
       //*    exec sql
       //*      update wrkfile
       //*        set createdate = trim(:wrkndxrcd.createdate), archivetype =
       //*              upper(:wrkndxrcd.archtype)
       //*        where current of c3;
     C                   EVAL      SQL_00173    = WRKNDXRCD.CREATEDATE          SQL
     C                   EVAL      SQL_00174    = WRKNDXRCD.ARCHTYPE            SQL
     C                   Z-ADD     -4            SQLER6                         SQL   32
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00168                      SQL
         endsl;
         prvNdxRcd  = wrkNdxRcd;
         doFetch(BS_DEDUP);
       enddo;

       if expCfgDta.addHdrRcd = 'Y';
         if CFGOBTYPE <> ' ';
       //*    exec sql
       //*      insert into hdrfile
       //*        values ('OnBaseExtCod', 'DiskFileName', 'DocumentClass',
       //*            'OnBaseExtCod', 'BatchNumber', 'Sequence', 'Blank',
       //*            'CreationDate', substr(:linkdef.lndxn1, 2, 9), substr(
       //*              :linkdef.lndxn2, 2, 9), substr(:linkdef.lndxn3, 2, 9),
       //*            substr(:linkdef.lndxn4, 2, 9), substr(:linkdef.lndxn5, 2,
       //*            substr(:linkdef.lndxn6, 2, 9), substr(:linkdef.lndxn7, 2,
       //*            'StartingPage', 'EndingPage', 'OnBaseKey1', 'OnBaseKey2',
       //*            'OnBaseDocTyp');
     C                   EVAL      SQL_00180    = LINKDEF.LNDXN1                SQL
     C                   EVAL      SQL_00181    = LINKDEF.LNDXN2                SQL
     C                   EVAL      SQL_00182    = LINKDEF.LNDXN3                SQL
     C                   EVAL      SQL_00183    = LINKDEF.LNDXN4                SQL
     C                   EVAL      SQL_00184    = LINKDEF.LNDXN5                SQL
     C                   EVAL      SQL_00185    = LINKDEF.LNDXN6                SQL
     C                   EVAL      SQL_00186    = LINKDEF.LNDXN7                SQL
     C                   Z-ADD     -4            SQLER6                         SQL   33
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00175                      SQL
         else;
           if expCfgDta.rptNdxFmt = 'I';
       //*      exec sql
       //*        insert into hdrfile
       //*          values ('DiskFileName', 'DocumentClass', 'DocType',
       //*              'BatchNumber', 'Sequence', 'Blank', 'CreationDate',
       //*              substr(:linkdef.lndxn1, 2, 9), substr(
       //*                :linkdef.lndxn2, 2, 9), substr(:linkdef.lndxn3, 2, 9),
       //*              substr(:linkdef.lndxn4, 2, 9), substr(
       //*                :linkdef.lndxn5, 2, 9), substr(:linkdef.lndxn6, 2, 9),
       //*              substr(:linkdef.lndxn7, 2, 9), 'StartingPage',
       //*              'EndingPage');
     C                   EVAL      SQL_00192    = LINKDEF.LNDXN1                SQL
     C                   EVAL      SQL_00193    = LINKDEF.LNDXN2                SQL
     C                   EVAL      SQL_00194    = LINKDEF.LNDXN3                SQL
     C                   EVAL      SQL_00195    = LINKDEF.LNDXN4                SQL
     C                   EVAL      SQL_00196    = LINKDEF.LNDXN5                SQL
     C                   EVAL      SQL_00197    = LINKDEF.LNDXN6                SQL
     C                   EVAL      SQL_00198    = LINKDEF.LNDXN7                SQL
     C                   Z-ADD     -4            SQLER6                         SQL   34
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00187                      SQL
           else;
       //*      exec sql
       //*        insert into hdrfile
       //*          values ('DiskFileName', 'Folder', 'Library', 'FileName',
       //*              'File#', 'FormType', 'TotalPages', 'LPI', 'CPI',
       //*              'CreateDate', 'CreateTime', 'DeviceType', 'OvrFlwLin',
       //*              'Font', 'PageRotate', 'MaxRcdLen', 'ArchDate',
       //*              'ExpireDate', 'ReportID', 'FmtType', 'AltCrtDate',
       //*              'AltCrtTime', 'ReportType');
          SQLER6 = 35;                                                          //SQL
          SQCALL000035(                                                         //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
           endif;
         endif;
         run('cpytoimpf fromfile(' + hdrFile +
         ') tostmf(' + sq + %trimr(cfgdir) + '/' +
           %trim(csvRptTyp) + '.CSV' + sq + ') mbropt(*replace) rcddlm(*crlf)' +
           ' RMVBLANK(*BOTH) ' +
           'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
           sq + %trim(fldDlm) + sq + ')');
         run('dltovr hdrfile lvl(*job)');
         run('dltf ' + %trimr(pgmLib) + '/' + hdrFile);
       endif;

       if expCfgDta.addHdrRcd = 'Y' and expCfgDta.csvFormat <> OLDCSV;
       //*  exec sql
       //*    insert into hdrfile
       //*      values ('Path', 'DocumentClass', 'DocType', 'BatchNumber',
       //*          'Sequence', 'Blank', 'CreationDate', substr(
       //*            :linkdef.lndxn1, 2, 9), substr(:linkdef.lndxn2, 2, 9),
       //*          substr(:linkdef.lndxn3, 2, 9), substr(:linkdef.lndxn4, 2, 9)
       //*          substr(:linkdef.lndxn5, 2, 9), substr(:linkdef.lndxn6, 2, 9)
       //*          substr(:linkdef.lndxn7, 2, 9));
     C                   EVAL      SQL_00204    = LINKDEF.LNDXN1                SQL
     C                   EVAL      SQL_00205    = LINKDEF.LNDXN2                SQL
     C                   EVAL      SQL_00206    = LINKDEF.LNDXN3                SQL
     C                   EVAL      SQL_00207    = LINKDEF.LNDXN4                SQL
     C                   EVAL      SQL_00208    = LINKDEF.LNDXN5                SQL
     C                   EVAL      SQL_00209    = LINKDEF.LNDXN6                SQL
     C                   EVAL      SQL_00210    = LINKDEF.LNDXN7                SQL
     C                   Z-ADD     -4            SQLER6                         SQL   36
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00199                      SQL
         run('cpytoimpf fromfile(' + hdrFile +
         ') tostmf(' + sq + %trimr(cfgdir) + '/' +
         %trim(csvRptTyp) + '.CSV' + sq + ') mbropt(*replace) rcddlm(*crlf)' +
         ' RMVBLANK(*BOTH) ' +
         'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
         sq + %trim(fldDlm) + sq + ')');
         run('dltovr hdrfile lvl(*job)');
         run('dltf ' + %trimr(pgmLib) + '/' + hdrFile);
       endif;

       if expCfgDta.csvFormat = OLDCSV;
         // Create secondary work file to contain the old format order.
         wrkFile2 = 'O' + %subst(wrkFile:2);
         textStmt = 'CREATE TABLE ' + %trimr(pgmLib) + '/' + %trimr(wrkFile2) +
         ' (CLASS CHAR (10) NOT NULL WITH DEFAULT,' +
         'CLASS2 CHAR (10) NOT NULL WITH DEFAULT,' +
         'BATCHCONST CHAR(5) NOT NULL WITH DEFAULT,' +
         'ID CHAR(10) NOT NULL WITH DEFAULT,' +
         'SEQCONST CHAR(3) NOT NULL WITH DEFAULT,' +
         'SEQNBR CHAR(9) NOT NULL WITH DEFAULT';
         linkNameP = %addr(linkDef.lndxn1);
         for i = 1 to %elem(ndxVals);
           if linkName(i) = ' ';
             leave;
           endif;
           textStmt = %trimr(textStmt) + ', NDXNAM' + %trim(%char(i)) +
           ' CHAR (10) NOT NULL WITH DEFAULT, NDXVAL' + %trim(%char(i)) +
           ' CHAR (70) NOT NULL WITH DEFAULT';
         endfor;
         textStmt = %trimr(textStmt) +
           ', DATENAME CHAR (10) NOT NULL WITH DEFAULT' +
           ', CREATEDATE CHAR (15) NOT NULL WITH DEFAULT' +
           ', FILEPATH CHAR (256) NOT NULL WITH DEFAULT)';
       //*  exec sql
       //*    execute immediate :textstmt;
          SQLER6 = 37;                                                          //SQL
          SQCALL000037(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL

         // Build SQL statement to put index data into old csv format.
         textStmt = 'insert into ' + %trimr(wrkFile2) +
         ' (CLASS, CLASS2, BATCHCONST, ID, SEQCONST, SEQNBR';
         for i = 1 to %elem(linkName);
           if linkName(i) = ' ';
             leave;
           endif;
           textStmt = %trimr(textStmt) + ', NDXNAM' + %trim(%char(i)) +
           ', NDXVAL' + %trim(%char(i));
         endfor;
         textStmt = %trimr(textStmt) + ',datename, createdate';
         textStmt = %trimr(textStmt) +
         ', filepath) select class, class,' + sq + 'Batch' + sq +
         ', id,' + sq + 'Seq' + sq + ', trim(char(seqnbr))';
         for i = 1 to %elem(linkName);
           if linkName(i) = ' ';
             leave;
           endif;
           textStmt = %trimr(textStmt) + ', ' +
           sq + %trimr(%subst(linkName(i):2)) + sq + ', index' +
           %trim(%char(i));
         endfor;
         textStmt = %trimr(textStmt) + ',' + sq + '$CRTDT' + sq;
         textStmt = %trimr(textStmt) + ', createdate';
         textStmt = %trimr(textStmt) + ', filepath from ' + wrkFile;
       //*  exec sql
       //*    execute immediate :textstmt;
          SQLER6 = 38;                                                          //SQL
          SQCALL000038(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL

         // Switch the original workfile name to the secondary workfile name.
         wrkFile = wrkFile2;
         csvPath = %trimr(cfgDir) + '/' + %trimr(csvRptTyp) + 'S.CSV' + x'00';
         // Open a handle to the CSV file.
         // Check to see if csv file exists first. If not, create it with ccsid.
         if access(%trimr(csvPath):F_OK) <> OK;
           csvFH = open(%trimr(csvPath):O_CREAT+O_WRONLY+O_CODEPAGE+O_SYNC:
           M_RWX:819);
           callp close(csvFH);
         endif;
         toStmfName = %trimr(csvRptTyp) + 'S';
         exsr cpyToCSV;
         run('dltf ' + %trimr(pgmLib) + '/' + wrkFile2);
         %subst(wrkFile:1:1) = 'X';
       endif;

       toStmfName = csvRptTyp;
       exsr cpyToCSV;

       run('dltovr wrkfile lvl(*job)');

       run('dltf ' + %trimr(pgmLib) + '/' + wrkFile);

       return;

       //*********************************************************
       begsr cpyToCSV;
       // copy the work index file contents back to csv file with replace option
         cmdStr = 'cpytoimpf fromfile(' + wrkfile +
         ') tostmf(' + sq + %trimr(cfgdir) + '/' +
         %trim(toStmfName) + '.CSV' + sq + ') rcddlm(*crlf)' +
         ' RMVBLANK(*BOTH) ' +
         'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
         sq + %trim(fldDlm) + sq + ')';
         if expCfgDta.addHdrRcd = 'Y' and expCfgDta.csvFormat <> OLDCSV;
           cmdStr = %trimr(cmdStr) + ' mbropt(*add)';
         else;
           cmdStr = %trimr(cmdStr) + ' mbropt(*replace)';
         endif;
         run(cmdStr);
       endsr;

       //*********************************************************
       begsr setCrtDate;
         select;
         when expCfgDta.crtDatFmt = 'MM/DD/YYYY';
           test(de) *iso0 wrkNdxRcd.createDate;
           if not %error; // In default ISO format. Convert to MM/DD/YYYY.
             wrkNdxRcd.createDate=%char(%date(wrkNdxRcd.createDate:*iso0):
               *usa/);
           endif;
         when expCfgDta.crtDatFmt = 'YYYYMMDD';
           test(de) *usa/ wrkNdxRcd.createDate;
           if not %error; // In default ISO format. Convert to MM/DD/YYYY.
             wrkNdxRcd.createDate=%char(%date(wrkNdxRcd.createDate:*usa/):
               *iso0);
           endif;
         when expCfgDta.crtDatFmt = 'CYYMMDD';
           test(de) *cymd0 wrkNdxRcd.createDate;
           if %error; // In default ISO format. Convert to CYYMMDD.
             wrkNdxRcd.createDate=%char(%date(wrkNdxRcd.createDate:*iso0):
               *cymd0);
           endif;
         endsl;
       endsr;
       //end-free
     p                 e

      **************************************************************************
     P exportNotes     B
     D exportNotes     PI
     D  docID                        10A   CONST
     D  sequence                     10i 0 const

     d notePath        s                   like(basePath)
     d textStmt        s           1024
     d expNotes      e ds                  extname(EXPNOTES)
     d annoFH          s             10i 0
     d bytesToWrite    s             10i 0
     d bytesLeft       s             10i 0
     d LF              c                   x'25'
     d chkObjRtn       s             10i 0

      /FREE

     D  SQCALL000039   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               CLOSE
     D  SQL_00211              1      2B 0 INZ(128)                             length of header
     D  SQL_00212              3      4B 0 INZ(40)                              statement number
     D  SQL_00213              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00214              9      9A   INZ('0')                             data is okay
     D  SQL_00215             10    127A                                        end of header
     D  SQL_00216            128    128A                                        end of header
     D  SQCALL000041   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00217              1      2B 0 INZ(128)                             length of header
     D  SQL_00218              3      4B 0 INZ(42)                              statement number
     D  SQL_00219              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00220              9      9A   INZ('0')                             data is okay
     D  SQL_00221             10    127A                                        end of header
     D  SQL_00222            128    128A                                        end of header
     D                 DS                  STATIC                               FETCH
     D  SQL_00223              1      2B 0 INZ(128)                             length of header
     D  SQL_00224              3      4B 0 INZ(43)                              statement number
     D  SQL_00225              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00226              9      9A   INZ('0')                             data is okay
     D  SQL_00227             10    127A                                        end of header
     D  SQL_00228            129    138A                                        NDBNUM
     D  SQL_00229            139    142B 0                                      NDBSEQ
     D  SQL_00230            143    146B 0                                      NDPAGN
     D  SQL_00231            147    150B 0                                      NDNOTN
     D  SQL_00232            151    154B 0                                      NDREVI
     D  SQL_00233            155    164A                                        NDUSER
     D  SQL_00234            165    168B 0                                      NDDATE
     D  SQL_00235            169    172B 0                                      NDTIME
     D  SQL_00236            173    173A                                        NDTYPE
     D  SQL_00237            174    178A                                        NDATYP
     D  SQL_00238            179    182B 0                                      NDALEN
     D  SQL_00239            183    232A                                        NDACOO
     D  SQL_00240            233    251A                                        NDADTA
     D  SQL_00241            252    261A                                        NDATFL
     D  SQL_00242            262    262A                                        NDACTN
     D  SQL_00243            263    266B 0                                      NDDCOD
     D  SQL_00244            267    270B 0                                      NDDTYP
     D  SQCALL000044   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
     D  P0001                              LIKE(TEXTSTMT)
     D                 DS                  STATIC                               OPEN
     D  SQL_00245              1      2B 0 INZ(128)                             length of header
     D  SQL_00246              3      4B 0 INZ(45)                              statement number
     D  SQL_00247              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00248              9      9A   INZ('0')                             data is okay
     D  SQL_00249             10    127A                                        end of header
     D  SQL_00250            129    138A                                        NDBNUM
     D  SQL_00251            139    142B 0                                      NDBSEQ
     D  SQL_00252            143    146B 0                                      NDPAGN
     D  SQL_00253            147    150B 0                                      NDNOTN
     D                 DS                  STATIC                               FETCH
     D  SQL_00254              1      2B 0 INZ(128)                             length of header
     D  SQL_00255              3      4B 0 INZ(46)                              statement number
     D  SQL_00256              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00257              9      9A   INZ('0')                             data is okay
     D  SQL_00258             10    127A                                        end of header
     D  SQL_00259            129   1152A                                        NOTEDATA
     D                 DS                  STATIC                               FETCH
     D  SQL_00260              1      2B 0 INZ(128)                             length of header
     D  SQL_00261              3      4B 0 INZ(47)                              statement number
     D  SQL_00262              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00263              9      9A   INZ('0')                             data is okay
     D  SQL_00264             10    127A                                        end of header
     D  SQL_00265            129   1152A                                        NOTEDATA
     D                 DS                  STATIC                               CLOSE
     D  SQL_00266              1      2B 0 INZ(128)                             length of header
     D  SQL_00267              3      4B 0 INZ(48)                              statement number
     D  SQL_00268              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00269              9      9A   INZ('0')                             data is okay
     D  SQL_00270             10    127A                                        end of header
     D  SQL_00271            128    128A                                        end of header
     D                 DS                  STATIC                               INSERT
     D  SQL_00272              1      2B 0 INZ(128)                             length of header
     D  SQL_00273              3      4B 0 INZ(49)                              statement number
     D  SQL_00274              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00275              9      9A   INZ('0')                             data is okay
     D  SQL_00276             10    127A                                        end of header
     D  SQL_00277            129    138A                                        EN_OBJID
     D  SQL_00278            139    148A                                        EN_SEQNBR
     D  SQL_00279            149    158A                                        EN_PAGENBR
     D  SQL_00280            159    168A                                        EN_NOTENBR
     D  SQL_00281            169    178A                                        EN_USER
     D  SQL_00282            179    188A                                        EN_DATE
     D  SQL_00283            189    196A                                        EN_TIME
     D  SQL_00284            197    226A                                        EN_TYPE
     D  SQL_00285            227    231A                                        EN_ULX
     D  SQL_00286            232    236A                                        EN_ULY
     D  SQL_00287            237    241A                                        EN_LRX
     D  SQL_00288            242    246A                                        EN_LRY
     D  SQL_00289            247    249A                                        EN_RGB_R1
     D  SQL_00290            250    252A                                        EN_RGB_G1
     D  SQL_00291            253    255A                                        EN_RGB_B1
     D  SQL_00292            256    258A                                        EN_RGB_R2
     D  SQL_00293            259    261A                                        EN_RGB_G2
     D  SQL_00294            262    264A                                        EN_RGB_B2
     D  SQL_00295            265    776A                                        EN_PATH
     D                 DS                  STATIC                               UPDATE
     D  SQL_00296              1      2B 0 INZ(128)                             length of header
     D  SQL_00297              3      4B 0 INZ(50)                              statement number
     D  SQL_00298              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00299              9      9A   INZ('0')                             data is okay
     D  SQL_00300             10    127A                                        end of header
     D  SQL_00301            129    138A                                        NDBNUM
     D                 DS                  STATIC                               FETCH
     D  SQL_00302              1      2B 0 INZ(128)                             length of header
     D  SQL_00303              3      4B 0 INZ(51)                              statement number
     D  SQL_00304              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00305              9      9A   INZ('0')                             data is okay
     D  SQL_00306             10    127A                                        end of header
     D  SQL_00307            129    138A                                        NDBNUM
     D  SQL_00308            139    142B 0                                      NDBSEQ
     D  SQL_00309            143    146B 0                                      NDPAGN
     D  SQL_00310            147    150B 0                                      NDNOTN
     D  SQL_00311            151    154B 0                                      NDREVI
     D  SQL_00312            155    164A                                        NDUSER
     D  SQL_00313            165    168B 0                                      NDDATE
     D  SQL_00314            169    172B 0                                      NDTIME
     D  SQL_00315            173    173A                                        NDTYPE
     D  SQL_00316            174    178A                                        NDATYP
     D  SQL_00317            179    182B 0                                      NDALEN
     D  SQL_00318            183    232A                                        NDACOO
     D  SQL_00319            233    251A                                        NDADTA
     D  SQL_00320            252    261A                                        NDATFL
     D  SQL_00321            262    262A                                        NDACTN
     D  SQL_00322            263    266B 0                                      NDDCOD
     D  SQL_00323            267    270B 0                                      NDDTYP
     D                 DS                  STATIC                               CLOSE
     D  SQL_00324              1      2B 0 INZ(128)                             length of header
     D  SQL_00325              3      4B 0 INZ(52)                              statement number
     D  SQL_00326              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00327              9      9A   INZ('0')                             data is okay
     D  SQL_00328             10    127A                                        end of header
     D  SQL_00329            128    128A                                        end of header
       if expcfgdta.expNotes <> 'Y';
         return;
       endif;

       // Create the annotation directory if it doesn't exist.
       notePath =  %trimr(cfgDir) + '/Annotations/';
       spyIFS('CRTPTH':notePath);

       // Create notes table if it doesn't exist.
       chkObj('EXPNOTES':'QTEMP':'*FILE':chkObjRtn);
       if chkObjRtn < 0;
         textStmt = 'create table qtemp';
         for i = 1 to %elem(crtnottbl);
           textStmt = %trimr(textStmt) + %trimr(crtnottbl(i));
         endfor;
       //*  exec sql
       //*    execute immediate :textstmt;
          SQLER6 = 39;                                                          //SQL
          SQCALL000039(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
         path = %trimr(cfgdir) + '/Annotations.CSV';
         run('CPYFRMIMPF FROMSTMF(' + sq + %trimr(path) + sq +
           ') TOFILE(qtemp/expnotes) MBROPT(*ADD) ' +
         'RCDDLM(*crLF) RMVBLANK(*BOTH) RPLNULLVAL(*FLDDFT) ' +
         'STRDLM(' + sq + %trim(strDlm) + sq + ') FLDDLM(' +
         sq + %trim(fldDlm) + sq + ')');
       endif;

       textStmt =
       'select * from mnotdir ' +
         'where left(ndacoo,2) <> ' + SQ + 'rs' + SQ + ' and ' +
         'mnotdir.ndbnum = ' + SQ + %trimr(docID) + SQ + ' and ';
       if %subst(docid:1:1) = 'B';
         textStmt = %trimr(textStmt) +
         ' mnotdir.ndbseq = ' + %trim(%char(sequence));
       else;
         textStmt = %trimr(textStmt) +
           ' mnotdir.ndpagn between ' + %trim(%char(rpt.spg)) + ' and ' +
           %trim(%char(rpt.epg));
       endif;

       // Add the note type filters.
       if expcfgdta.expNotes = 'Y';
         if %scan('Y':%str(%addr(noteFlagA))) > 0;
           textStmt = %trimr(textStmt) + ' and left(ndacoo,2) in(';
           for i = 1 to %elem(noteFlagA);
             if noteFlagA(i) = 'Y';
               if %subst(textStmt:%len(%trimr(textStmt))-2:3) <> 'in(';
                 textStmt = %trimr(textStmt) + ',';
               endif;
               textStmt = %trimr(textStmt) + SQ + noteTypesA(i) + SQ;
             endif;
           endfor;
           textStmt = %trimr(textStmt) + ')';
         endif;
       endif;

       // Order the note list.
       textStmt = %trimr(textStmt) +
         ' ORDER BY ndbnum,ndbseq,ndpagn,ndnotn';

       //*exec sql
       //*  close c4;
     C                   Z-ADD     40            SQLER6                         SQL
     C     SQL_00213     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00211                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00211                      SQL
     C                   END                                                    SQL
       //*exec sql
       //*  prepare sqlstmt4 from :textstmt;
          SQLER6 = 41;                                                          //SQL
          SQCALL000041(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*exec sql
       //*  declare c4 cursor for sqlstmt4;
       //*exec sql
       //*  open c4;
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00219     IFEQ      0                                            SQL
     C     SQL_00220     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00217                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00217                      SQL
     C                   END                                                    SQL

       //*exec sql
       //*  fetch c4
       //*    into :noteheader;
     C                   Z-ADD     -4            SQLER6                         SQL   43
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00223                      SQL
     C     SQL_00226     IFEQ      '1'                                          SQL
     C                   EVAL      NDBNUM = SQL_00228                           SQL
     C                   EVAL      NDBSEQ = SQL_00229                           SQL
     C                   EVAL      NDPAGN = SQL_00230                           SQL
     C                   EVAL      NDNOTN = SQL_00231                           SQL
     C                   EVAL      NDREVI = SQL_00232                           SQL
     C                   EVAL      NDUSER = SQL_00233                           SQL
     C                   EVAL      NDDATE = SQL_00234                           SQL
     C                   EVAL      NDTIME = SQL_00235                           SQL
     C                   EVAL      NDTYPE = SQL_00236                           SQL
     C                   EVAL      NDATYP = SQL_00237                           SQL
     C                   EVAL      NDALEN = SQL_00238                           SQL
     C                   EVAL      NDACOO = SQL_00239                           SQL
     C                   EVAL      NDADTA = SQL_00240                           SQL
     C                   EVAL      NDATFL = SQL_00241                           SQL
     C                   EVAL      NDACTN = SQL_00242                           SQL
     C                   EVAL      NDDCOD = SQL_00243                           SQL
     C                   EVAL      NDDTYP = SQL_00244                           SQL
     C                   END                                                    SQL
       dow sqlcod = OK;
         clear expNotes;
         en_objid = ndbnum;
         if %subst(ndbnum:1:1) = 'B';
           en_seqnbr = %char(img.lxseq);
         else;
           en_seqnbr = %char(getSeqNum(ndbnum:ndpagn));
         endif;
         en_pagenbr = %char(ndpagn);
         en_notenbr = %char(ndnotn);
         en_user = nduser;
         en_date = %char(nddate);
         if expCfgDta.crtDatFmt = 'MM/DD/YYYY';
           en_date = %char(%date(en_date:*iso0):*usa);
         endif;
         en_time = %char(%time(ndtime:*iso));
         en_type = noteTypeText(%lookup(%subst(ndacoo:1:2):noteTypesA));
         en_ulx = %subst(ndacoo:3:5);
         en_uly = %subst(ndacoo:8:5);
         en_lrx = %subst(ndacoo:13:5);
         en_lry = %subst(ndacoo:18:5);
         en_rgb_r1 = %subst(ndacoo:23:3);
         en_rgb_g1 = %subst(ndacoo:26:3);
         en_rgb_b1 = %subst(ndacoo:29:3);
         en_rgb_r2 = %subst(ndacoo:32:3);
         en_rgb_g2 = %subst(ndacoo:35:3);
         en_rgb_b2 = %subst(ndacoo:38:3);
         if ndatfl <> ' ';
           run('ovrdbf notedetail ' + ndatfl + ' ovrscope(*job)');
           textStmt = 'select nadata from notedetail where nabnum = ? and ' +
           'nabseq = ? and napagn = ? and nanotn = ? order by nanseq';
       //*    exec sql
       //*      prepare sqlstmt5 from :textstmt;
          SQLER6 = 44;                                                          //SQL
          SQCALL000044(                                                         //SQL
               SQLCA                                                            //SQL
             : TEXTSTMT                                                         //SQL
          );                                                                    //SQL
       //*    exec sql
       //*      declare c5 cursor for sqlstmt5;
       //*    exec sql
       //*      open c5 using :ndbnum, :ndbseq, :ndpagn, :ndnotn;
     C                   EVAL      SQL_00250    = NDBNUM                        SQL
     C                   EVAL      SQL_00251    = NDBSEQ                        SQL
     C                   EVAL      SQL_00252    = NDPAGN                        SQL
     C                   EVAL      SQL_00253    = NDNOTN                        SQL
     C                   Z-ADD     -4            SQLER6                         SQL
     C     SQL_00247     IFEQ      0                                            SQL
     C     SQL_00248     ORNE      *LOVAL                                       SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00245                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLOPEN                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00245                      SQL
     C                   END                                                    SQL
       //*    exec sql
       //*      fetch c5
       //*        into :notedata;
     C                   Z-ADD     -4            SQLER6                         SQL   46
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00254                      SQL
     C     SQL_00257     IFEQ      '1'                                          SQL
     C                   EVAL      NOTEDATA = SQL_00259                         SQL
     C                   END                                                    SQL
           if ndatyp = ' ';
             ndatyp = 'TXT';
           endif;
           path = %trimr(notePath) + 'anno.' + %trimr(ndatyp);
           // Create a unique file name for the binary note attachment.
           spyIFS('DUPFIL':path);
           en_path = fileNameFromPath(path);
           annoFH = open(%trimr(path):O_CREAT+O_CCSID+O_TRUNC+O_WRONLY:M_RWX:
           819);
           bytesLeft = ndalen;
           dow sqlcod = OK;
             bytesToWrite = 1024;
             if bytesToWrite > bytesLeft;
               bytesToWrite = bytesLeft;
             endif;
             if en_type = 'TEXTNOTE' or en_type = 'STICKYNOTE';
               noteData = %xlate(fTable:tTable:noteData);
             endif;
             rc = write(annoFH:%addr(noteData):bytesToWrite);
             bytesLeft -= bytesToWrite;
       //*      exec sql
       //*        fetch c5
       //*          into :notedata;
     C                   Z-ADD     -4            SQLER6                         SQL   47
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00260                      SQL
     C     SQL_00263     IFEQ      '1'                                          SQL
     C                   EVAL      NOTEDATA = SQL_00265                         SQL
     C                   END                                                    SQL
           enddo;
       //*    exec sql
       //*      close c5;
     C                   Z-ADD     48            SQLER6                         SQL
     C     SQL_00268     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00266                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00266                      SQL
     C                   END                                                    SQL
           callp(e) close(annoFH);
           run('dltovr noteDetail lvl(*job)');
         endif;
       //*  exec sql
       //*    insert into qtemp/expnotes
       //*      values (:expnotes);
     C                   EVAL      SQL_00277    = EN_OBJID                      SQL
     C                   EVAL      SQL_00278    = EN_SEQNBR                     SQL
     C                   EVAL      SQL_00279    = EN_PAGENBR                    SQL
     C                   EVAL      SQL_00280    = EN_NOTENBR                    SQL
     C                   EVAL      SQL_00281    = EN_USER                       SQL
     C                   EVAL      SQL_00282    = EN_DATE                       SQL
     C                   EVAL      SQL_00283    = EN_TIME                       SQL
     C                   EVAL      SQL_00284    = EN_TYPE                       SQL
     C                   EVAL      SQL_00285    = EN_ULX                        SQL
     C                   EVAL      SQL_00286    = EN_ULY                        SQL
     C                   EVAL      SQL_00287    = EN_LRX                        SQL
     C                   EVAL      SQL_00288    = EN_LRY                        SQL
     C                   EVAL      SQL_00289    = EN_RGB_R1                     SQL
     C                   EVAL      SQL_00290    = EN_RGB_G1                     SQL
     C                   EVAL      SQL_00291    = EN_RGB_B1                     SQL
     C                   EVAL      SQL_00292    = EN_RGB_R2                     SQL
     C                   EVAL      SQL_00293    = EN_RGB_G2                     SQL
     C                   EVAL      SQL_00294    = EN_RGB_B2                     SQL
     C                   EVAL      SQL_00295    = EN_PATH                       SQL
     C                   Z-ADD     -4            SQLER6                         SQL   49
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00272                      SQL
       //*  exec sql
       //*    update explog
       //*      set logexpnot = 'Y'
       //*      where logobjid = :ndbnum;
     C                   EVAL      SQL_00301    = NDBNUM                        SQL
     C                   Z-ADD     -4            SQLER6                         SQL   50
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00296                      SQL
       //*  exec sql
       //*    fetch c4
       //*      into :noteheader;
     C                   Z-ADD     -4            SQLER6                         SQL   51
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00302                      SQL
     C     SQL_00305     IFEQ      '1'                                          SQL
     C                   EVAL      NDBNUM = SQL_00307                           SQL
     C                   EVAL      NDBSEQ = SQL_00308                           SQL
     C                   EVAL      NDPAGN = SQL_00309                           SQL
     C                   EVAL      NDNOTN = SQL_00310                           SQL
     C                   EVAL      NDREVI = SQL_00311                           SQL
     C                   EVAL      NDUSER = SQL_00312                           SQL
     C                   EVAL      NDDATE = SQL_00313                           SQL
     C                   EVAL      NDTIME = SQL_00314                           SQL
     C                   EVAL      NDTYPE = SQL_00315                           SQL
     C                   EVAL      NDATYP = SQL_00316                           SQL
     C                   EVAL      NDALEN = SQL_00317                           SQL
     C                   EVAL      NDACOO = SQL_00318                           SQL
     C                   EVAL      NDADTA = SQL_00319                           SQL
     C                   EVAL      NDATFL = SQL_00320                           SQL
     C                   EVAL      NDACTN = SQL_00321                           SQL
     C                   EVAL      NDDCOD = SQL_00322                           SQL
     C                   EVAL      NDDTYP = SQL_00323                           SQL
     C                   END                                                    SQL
       enddo;

       //*exec sql
       //*  close c4;
     C                   Z-ADD     52            SQLER6                         SQL
     C     SQL_00326     IFEQ      0                                            SQL
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00324                      SQL
     C                   ELSE                                                   SQL
     C                   CALL      SQLCLSE                                      SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00324                      SQL
     C                   END                                                    SQL

       return;

      /END-FREE
     P exportNotes     E

      **************************************************************************
     p getSeqNum       b
     d                 pi            10i 0
     d objectID                      10    const
     d seqNbr                        10i 0 const

     d lastObjectID    s                   like(objectID) static
     d docType         s             10
     d rrnam           s             10
     d rjnam           s             10
     d rpnam           s             10
     d runam           s             10
     d rudat           s             10
     d lxseq           s             10i 0
     d lnkfil          s             10

      /free
       // Get the link file name only when the batch/repind change for the
       // list of notes.

     D                 DS                  STATIC                               SELECT
     D  SQL_00330              1      2B 0 INZ(128)                             length of header
     D  SQL_00331              3      4B 0 INZ(53)                              statement number
     D  SQL_00332              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00333              9      9A   INZ('0')                             data is okay
     D  SQL_00334             10    127A                                        end of header
     D  SQL_00335            129    138A                                        OBJECTID
     D  SQL_00336            139    148A                                        DOCTYPE
     D                 DS                  STATIC                               SELECT
     D  SQL_00337              1      2B 0 INZ(128)                             length of header
     D  SQL_00338              3      4B 0 INZ(54)                              statement number
     D  SQL_00339              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00340              9      9A   INZ('0')                             data is okay
     D  SQL_00341             10    127A                                        end of header
     D  SQL_00342            129    138A                                        OBJECTID
     D  SQL_00343            139    148A                                        DOCTYPE
     D                 DS                  STATIC                               SELECT
     D  SQL_00344              1      2B 0 INZ(128)                             length of header
     D  SQL_00345              3      4B 0 INZ(55)                              statement number
     D  SQL_00346              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00347              9      9A   INZ('0')                             data is okay
     D  SQL_00348             10    127A                                        end of header
     D  SQL_00349            129    138A                                        DOCTYPE
     D  SQL_00350            139    148A                                        RRNAM
     D  SQL_00351            149    158A                                        RJNAM
     D  SQL_00352            159    168A                                        RPNAM
     D  SQL_00353            169    178A                                        RUNAM
     D  SQL_00354            179    188A                                        RUDAT
     D                 DS                  STATIC                               SELECT
     D  SQL_00355              1      2B 0 INZ(128)                             length of header
     D  SQL_00356              3      4B 0 INZ(56)                              statement number
     D  SQL_00357              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00358              9      9A   INZ('0')                             data is okay
     D  SQL_00359             10    127A                                        end of header
     D  SQL_00360            129    138A                                        RRNAM
     D  SQL_00361            139    148A                                        RJNAM
     D  SQL_00362            149    158A                                        RPNAM
     D  SQL_00363            159    168A                                        RUNAM
     D  SQL_00364            169    178A                                        RUDAT
     D  SQL_00365            179    188A                                        LNKFIL
     D                 DS                  STATIC                               SELECT
     D  SQL_00366              1      2B 0 INZ(128)                             length of header
     D  SQL_00367              3      4B 0 INZ(57)                              statement number
     D  SQL_00368              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00369              9      9A   INZ('0')                             data is okay
     D  SQL_00370             10    127A                                        end of header
     D  SQL_00371            129    138A                                        OBJECTID
     D  SQL_00372            139    142I 0                                      SEQNBR
     D  SQL_00373            143    146I 0                                      LXSEQ
     D                 DS                  STATIC                               SELECT
     D  SQL_00374              1      2B 0 INZ(128)                             length of header
     D  SQL_00375              3      4B 0 INZ(58)                              statement number
     D  SQL_00376              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00377              9      9A   INZ('0')                             data is okay
     D  SQL_00378             10    127A                                        end of header
     D  SQL_00379            129    138A                                        OBJECTID
     D  SQL_00380            139    142I 0                                      SEQNBR
     D  SQL_00381            143    146I 0                                      LXSEQ
       if objectID <> lastObjectID;
         run('dltovr lnkfil lvl(*job)');
         lastObjectID = objectID;
         if %subst(objectID:1:1) = 'B';
       //*    exec sql
       //*      select idrtyp
       //*        into :doctype
       //*        from mimgdir
       //*        where idbnum = :objectid;
     C                   EVAL      SQL_00335    = OBJECTID                      SQL
     C                   Z-ADD     -4            SQLER6                         SQL   53
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00330                      SQL
     C     SQL_00333     IFEQ      '1'                                          SQL
     C                   EVAL      DOCTYPE = SQL_00336                          SQL
     C                   END                                                    SQL
         else;
       //*    exec sql
       //*      select rpttyp
       //*        into :doctype
       //*        from mrptdir
       //*        where repind = :objectid;
     C                   EVAL      SQL_00342    = OBJECTID                      SQL
     C                   Z-ADD     -4            SQLER6                         SQL   54
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00337                      SQL
     C     SQL_00340     IFEQ      '1'                                          SQL
     C                   EVAL      DOCTYPE = SQL_00343                          SQL
     C                   END                                                    SQL
         endif;
         // Get big5 key to fetch
       //*  exec sql
       //*    select rrnam, rjnam, rpnam, runam, rudat
       //*      into :rrnam, :rjnam, :rpnam, :runam, :rudat
       //*      from rmaint
       //*      where rtypid = :doctype;
     C                   EVAL      SQL_00349    = DOCTYPE                       SQL
     C                   Z-ADD     -4            SQLER6                         SQL   55
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00344                      SQL
     C     SQL_00347     IFEQ      '1'                                          SQL
     C                   EVAL      RRNAM = SQL_00350                            SQL
     C                   EVAL      RJNAM = SQL_00351                            SQL
     C                   EVAL      RPNAM = SQL_00352                            SQL
     C                   EVAL      RUNAM = SQL_00353                            SQL
     C                   EVAL      RUDAT = SQL_00354                            SQL
     C                   END                                                    SQL
         // Get the link file from rlnkdef.
       //*  exec sql
       //*    select lnkfil
       //*      into :lnkfil
       //*      from rlnkdef
       //*      where lrnam = :rrnam and ljnam = :rjnam and lpnam = :rpnam and
       //*            lunam = :runam and ludat = :rudat;
     C                   EVAL      SQL_00360    = RRNAM                         SQL
     C                   EVAL      SQL_00361    = RJNAM                         SQL
     C                   EVAL      SQL_00362    = RPNAM                         SQL
     C                   EVAL      SQL_00363    = RUNAM                         SQL
     C                   EVAL      SQL_00364    = RUDAT                         SQL
     C                   Z-ADD     -4            SQLER6                         SQL   56
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00355                      SQL
     C     SQL_00358     IFEQ      '1'                                          SQL
     C                   EVAL      LNKFIL = SQL_00365                           SQL
     C                   END                                                    SQL
         run('ovrdbf lnkfil ' + lnkfil + ' ovrscope(*job)');
       endif;
       if %subst(objectID:1:1) = 'B';
       //*  exec sql
       //*    select lxseq
       //*      into :lxseq
       //*      from lnkfil
       //*      where ldxnam = :objectid and lxspg = :seqnbr;
     C                   EVAL      SQL_00371    = OBJECTID                      SQL
     C                   EVAL      SQL_00372    = SEQNBR                        SQL
     C                   Z-ADD     -4            SQLER6                         SQL   57
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00366                      SQL
     C     SQL_00369     IFEQ      '1'                                          SQL
     C                   EVAL      LXSEQ = SQL_00373                            SQL
     C                   END                                                    SQL
       else;
       //*  exec sql
       //*    select lxseq
       //*      into :lxseq
       //*      from lnkfil
       //*      where ldxnam = :objectid and :seqnbr between lxspg and lxepg;
     C                   EVAL      SQL_00379    = OBJECTID                      SQL
     C                   EVAL      SQL_00380    = SEQNBR                        SQL
     C                   Z-ADD     -4            SQLER6                         SQL   58
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00374                      SQL
     C     SQL_00377     IFEQ      '1'                                          SQL
     C                   EVAL      LXSEQ = SQL_00381                            SQL
     C                   END                                                    SQL
       endif;

       return lxseq;

      /end-free
     p                 e
     P*--------------------------------------------------
     P* Procedure name: addIndexTest
     P* Purpose:        Add index criteria to sql command
     P* Returns:
     P*--------------------------------------------------
     P addIndexTest    B
     D addIndexTest    PI
     d stmt                        1024
     d stmtType                       1    const
     d i               s              5i 0
     d oper            s              4

      /FREE

       // No index criteria defined...return.
       if %str(cfgNdxP:%len(cfgIndices(1)) * %elem(cfgIndices)) = ' ';
         return;
       endif;

       for i = 1 to %elem(cfgIndices);
         if cfgIndices(i) <> ' ';
           oper = '=';
           // Look for wildcard.
           if %subst(cfgIndices(i):1:1) = '%' or
           %subst(cfgIndices(i):%len(%trim(cfgIndices(i))):1) = '%';
             oper = 'like';
           endif;
           stmt = %trimr(stmt) + ' and trim(lxiv' + %trim(%char(i)) +
           ') like ' + SQ + %trim(cfgIndices(i)) + SQ;
         endif;
       endfor;

       return;

      /END-FREE
     P addIndexTest    E

      **************************************************************************
     p fileNameFromPath...
     p                 b
     d                 pi           128
     d pathIn                       256    const
     d rtnFileName     s            128
     d endPos          s              5i 0
     d i               s              5i 0
      /free
       endPos = %len(%trimr(pathIn));
       for i = endPos downto 1;
         if %subst(pathIn:i:1) = '/';
           rtnFileName = %subst(pathIn:i+1:endPos-i+1);
           leave;
         endif;
       endfor;
       return rtnFileName;
      /end-free
     p                 e

     P*--------------------------------------------------
     P* Procedure name: exportByCSVInput
     P* Purpose:        Export driven by CSV input file.
     P* Returns:
     P*--------------------------------------------------
     P exportByCSVInput...
     P                 B
     D exportByCSVInput...
     D                 PI

      /FREE

     D  SQCALL000059   PR                  EXTPGM(SQLROUTE)
     D  CA                                 LIKEDS(SQLCA)
       if %addr(csvDirIn) = *NULL;
         return;
       endif;
       exportByCSV = *on;

       //*exec sql
       //*  create table qtemp/csvinput (
       //*        ldxnam char(10) not null with default,
       //*        lxseq int not null with default,
       //*        lxiv1 char(99) not null with default,
       //*        lxiv2 char(99) not null with default,
       //*        lxiv3 char(99) not null with default,
       //*        lxiv4 char(99) not null with default,
       //*        lxiv5 char(99) not null with default,
       //*        lxiv6 char(99) not null with default,
       //*        lxiv7 char(99) not null with default,
       //*        lxiv8 char(8) not null with default,
       //*        lxtyp char(1) not null with default,
       //*        lxspg int not null with default,
       //*        lxepg int not null with default 0);
          SQLER6 = 59;                                                          //SQL
          SQCALL000059(                                                         //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL

       run('CPYFRMIMPF FROMSTMF(' + sq + %trimr(csvDirIn)+ sq +
         ') TOFILE(QTEMP/CSVINPUT) MBROPT(*ADD) ' +
       'RCDDLM(*CRLF) RMVBLANK(*BOTH) RPLNULLVAL(*FLDDFT)');

       return;

      /END-FREE
     P exportByCSVInput...
     P                 E
      **********************************************************************
     P getLnkDef       b
     d                 pi            10i 0
     d inputDoctype                  10
      /free
     D                 DS                  STATIC                               SELECT
     D  SQL_00382              1      2B 0 INZ(128)                             length of header
     D  SQL_00383              3      4B 0 INZ(60)                              statement number
     D  SQL_00384              5      8B 0 INZ(0)                               invocation mark
     D  SQL_00385              9      9A   INZ('0')                             data is okay
     D  SQL_00386             10    127A                                        end of header
     D  SQL_00387            129    138A                                        INPUTDOCTYPE
     D  SQL_00388            139    148A                                        LINKDEF.LRNAM
     D  SQL_00389            149    158A                                        LINKDEF.LJNAM
     D  SQL_00390            159    168A                                        LINKDEF.LPNAM
     D  SQL_00391            169    178A                                        LINKDEF.LUNAM
     D  SQL_00392            179    188A                                        LINKDEF.LUDAT
     D  SQL_00393            189    198A                                        LINKDEF.LNDXN1
     D  SQL_00394            199    208A                                        LINKDEF.LNDXN2
     D  SQL_00395            209    218A                                        LINKDEF.LNDXN3
     D  SQL_00396            219    228A                                        LINKDEF.LNDXN4
     D  SQL_00397            229    238A                                        LINKDEF.LNDXN5
     D  SQL_00398            239    248A                                        LINKDEF.LNDXN6
     D  SQL_00399            249    258A                                        LINKDEF.LNDXN7
     D  SQL_00400            259    259A                                        LINKDEF.LPOSTO
     D  SQL_00401            260    269A                                        LINKDEF.LNKFIL
     D  SQL_00402            270    270A                                        LINKDEF.LDTDES
     D  SQL_00403            271    278A                                        LINKDEF.LIFCAB
     D  SQL_00404            279    318A                                        LINKDEF.LICASE
     D  SQL_00405            319    326A                                        LINKDEF.LIDOC
     D  SQL_00406            327    327A                                        LINKDEF.LIREF1
     D  SQL_00407            328    328A                                        LINKDEF.LIREF2
     D  SQL_00408            329    329A                                        LINKDEF.LIREF3
     D  SQL_00409            330    330A                                        LINKDEF.LIREF4
     D  SQL_00410            331    331A                                        LINKDEF.LIREF5
     D  SQL_00411            332    332A                                        LINKDEF.LIREF6
     D  SQL_00412            333    333A                                        LINKDEF.LIREF7
     D  SQL_00413            334    336P 4                                      LINKDEF.LNDXF1
     D  SQL_00414            337    339P 4                                      LINKDEF.LNDXF2
     D  SQL_00415            340    342P 4                                      LINKDEF.LNDXF3
     D  SQL_00416            343    345P 4                                      LINKDEF.LNDXF4
     D  SQL_00417            346    348P 4                                      LINKDEF.LNDXF5
     D  SQL_00418            349    351P 4                                      LINKDEF.LNDXF6
     D  SQL_00419            352    354P 4                                      LINKDEF.LNDXF7
     D  SQL_00420            355    357P 4                                      LINKDEF.LNDXF8
     D  SQL_00421            358    367A                                        LINKDEF.RDSPF
       if inputDocType = '*ALL';
         return OK;
       endif;
       //*exec sql
       //*  select rlnkdef.*
       //*    into :linkdef
       //*    from
       //*      rlnkdef
       //*      left join rmaint
       //*        on rrnam = lrnam and rjnam = ljnam and rpnam = lpnam and runam
       //*          lunam and rudat = ludat
       //*    where rtypid = :inputdoctype;
     C                   EVAL      SQL_00387    = INPUTDOCTYPE                  SQL
     C                   Z-ADD     -4            SQLER6                         SQL   60
     C                   CALL      SQLROUTE                                     SQL
     C                   PARM                    SQLCA                          SQL
     C                   PARM                    SQL_00382                      SQL
     C     SQL_00385     IFEQ      '1'                                          SQL
     C                   EVAL      LINKDEF.LRNAM = SQL_00388                    SQL
     C                   EVAL      LINKDEF.LJNAM = SQL_00389                    SQL
     C                   EVAL      LINKDEF.LPNAM = SQL_00390                    SQL
     C                   EVAL      LINKDEF.LUNAM = SQL_00391                    SQL
     C                   EVAL      LINKDEF.LUDAT = SQL_00392                    SQL
     C                   EVAL      LINKDEF.LNDXN1 = SQL_00393                   SQL
     C                   EVAL      LINKDEF.LNDXN2 = SQL_00394                   SQL
     C                   EVAL      LINKDEF.LNDXN3 = SQL_00395                   SQL
     C                   EVAL      LINKDEF.LNDXN4 = SQL_00396                   SQL
     C                   EVAL      LINKDEF.LNDXN5 = SQL_00397                   SQL
     C                   EVAL      LINKDEF.LNDXN6 = SQL_00398                   SQL
     C                   EVAL      LINKDEF.LNDXN7 = SQL_00399                   SQL
     C                   EVAL      LINKDEF.LPOSTO = SQL_00400                   SQL
     C                   EVAL      LINKDEF.LNKFIL = SQL_00401                   SQL
     C                   EVAL      LINKDEF.LDTDES = SQL_00402                   SQL
     C                   EVAL      LINKDEF.LIFCAB = SQL_00403                   SQL
     C                   EVAL      LINKDEF.LICASE = SQL_00404                   SQL
     C                   EVAL      LINKDEF.LIDOC = SQL_00405                    SQL
     C                   EVAL      LINKDEF.LIREF1 = SQL_00406                   SQL
     C                   EVAL      LINKDEF.LIREF2 = SQL_00407                   SQL
     C                   EVAL      LINKDEF.LIREF3 = SQL_00408                   SQL
     C                   EVAL      LINKDEF.LIREF4 = SQL_00409                   SQL
     C                   EVAL      LINKDEF.LIREF5 = SQL_00410                   SQL
     C                   EVAL      LINKDEF.LIREF6 = SQL_00411                   SQL
     C                   EVAL      LINKDEF.LIREF7 = SQL_00412                   SQL
     C                   EVAL      LINKDEF.LNDXF1 = SQL_00413                   SQL
     C                   EVAL      LINKDEF.LNDXF2 = SQL_00414                   SQL
     C                   EVAL      LINKDEF.LNDXF3 = SQL_00415                   SQL
     C                   EVAL      LINKDEF.LNDXF4 = SQL_00416                   SQL
     C                   EVAL      LINKDEF.LNDXF5 = SQL_00417                   SQL
     C                   EVAL      LINKDEF.LNDXF6 = SQL_00418                   SQL
     C                   EVAL      LINKDEF.LNDXF7 = SQL_00419                   SQL
     C                   EVAL      LINKDEF.LNDXF8 = SQL_00420                   SQL
     C                   EVAL      LINKDEF.RDSPF = SQL_00421                    SQL
     C                   END                                                    SQL
       if sqlcod <> OK and expcfgdta.expRptsAS = 'D';
         writeLog(cfgFolder:inputDocType:'Warning':0:0:
         'Link definition not found.');
         return -1;
       endif;
       return OK;
      /end-free
     P                 E

     P* --------------------------------------------------
     P* Procedure name: setup4NativePDF
     P* Purpose:        Use export capability in MAG2038 for native PDF docum...
     P*                          ents
     P* Returns:
     P* --------------------------------------------------
     Psetup4output     B
     Dsetup4output     PI
     D pathBase                     256
     d timeKey                        6
     d pathRtn                      256

     d sndDtaq         pr                  extpgm('QSNDDTAQ')
     d  qName                        10    const
     d  qLib                         10    const
     d  qMsgSiz                       5  0 const
     d  qDta                               likeds(dqMsg)
     d  qKeySiz                       3  0 const
     d  key                                likeds(dqKey)
     d dqKey           ds            20    qualified
     d  job                           6
     d  time                          6

     D DQMSG           DS           256
      * Data Que Message  (*Entry extensions)
     D  @DEST                  1      1
     D  RQOBTY                 2      2
     D  RQRPT                  3     12
     D  RQFRM                 13     22
     D  RQUD                  23     32
     D  RQSPAG                33     39  0
     D  RQEPAG                40     46  0
     D  RQPTRA                47     55  0
     D  RQPTRD                56     64  0
     D  RQPTRP                65     73  0
     D  RQFLDR                74     83
     D  RQFLIB                84     93
     D  RQLOC                 94     94
     D  RQOPTF                95    104
     D  RQPTYP               105    114
     D  RQIDX                115    124
     D  RQMBR                125    134
     D  RQPWND               135    135
     D  RQEUSR               136    145
     D  RQENAM               146    155
     D  RQNWND               156    158  0
     D  RQIMPG               159    178
     d  rqNotesPrint         179    179

     d fileNameSeq     s             10s 0 static
     d lastRepInd      s             10    static

      /free

       // LDA ************************
       in(e) lda;
       clear lda;
       mlind = '*IFS';
       mlsubj = 'EXPOBJSPY.TXT';
       mlpath = pathBase;
       if rpt.repind = lastRepInd and expCfgDta.expRptsAS = 'D';
         fileNameSeq += 1;
       else;
         fileNameSeq = 0;
       endif;
       lastRepInd = rpt.repind;
       iflnam = %editc(fileNameSeq:'X');
       if expCfgDta.expRptsAS = 'R';
         iflnam = rpt.repind;
       endif;
       path = %trimr(pathBase) + rpt.repind;
       if cfgCvtPDF = 'Y';
         path = %trimr(path) + '.pdf';
       else;
         path = %trimr(path) + '.TXT';
       endif;
       if rpt.apftyp = '4';
         path = %trimr(pathBase) + iflnam + '.pdf';
         dow access(%trimr(path):F_OK) = OK and expCfgDta.expRptsAS = 'D';
           fileNameSeq += 1;
           iflnam = %editc(fileNameSeq:'X');
           path = %trimr(pathBase) + iflnam + '.pdf';
         enddo;
         if expCfgDta.expRptsAS = 'R' and access(%trimr(path):F_OK) = OK;
           return;
         endif;
       else;
         if  expCfgDta.expRptsAS = 'D';
           spyifs('DUPFIL':path);
         endif;
       endif;
       pathRtn = path;
       mlpath = pathRtn;
       if rpt.apftyp = '4';
         mlpath = %trimr(pathBase) + '*';
       endif;
       mltype = 'A'; //IFS PDF
       iflist = '*NONE';
       ifrepl = 'N';
       if rpt.apftyp = '4';
         ifrepl = 'Y';
       endif;
       mlcdpg = '00437';
       mligba = 'N';
       out(e) lda;
       // END LDA *********************

       // MAG210 DATA QUEUE
       clear dqmsg;
       @dest = 'A';
       if rpt.apftyp = ' ' and cfgCvtPDF <> 'Y';
         if cfgoutq <> ' ';
           @dest = 'P';
         else;
           @dest = 'I';
         endif;
       endif;
       RQLOC = rpt.reploc;
       RQOPTF = rpt.ofrnam;
       rqobty = curObjTyp; // R = Report
       rqrpt = '*ORIG';
       rqfrm = '*ORIG';
       rqud = '*ORIG';
       rqspag = 1;
       rqepag = rpt.totpag;
       if expCfgDta.expRptsAS = 'D' or rpt.apftyp = '3';
         rqspag = rpt.spg;
         rqepag = rpt.epg;
       endif;
       rqptra = rpt.locsfa;
       rqptrd = rpt.locsfd;
       rqptrp = rpt.locsfp;
       rqfldr = rpt.fldr;
       rqflib = rpt.fldrlb;
       rqmbr  = rpt.repind;
       rqpwnd = 'N';
       rqeusr = user;
       rqenam = '*ALL';
       rqnotesprint = 'N';
       dqKey.job = jobNbr;
       dqKey.time = %char(%time():*iso0);
       timeKey = dqKey.time;
       sndDtaq('MAG210':'*LIBL':256:DQMSG:20:dqKey);
       // Send a quit record to the dataq
       @dest = 'Q';
       sndDtaq('MAG210':'*LIBL':256:DQMSG:20:dqKey);
       // END MAG210 DATA QUEUE

       return;

      /end-free

     P                 E

      ************************************************************************
      * Return the file extension from the path
      ************************************************************************
     P extFromPath     B
     D                 PI             4
     D  inPath                      256
     D pathIn          s            256
     D rtnVal          s              4
     d endPos          s              5i 0
     d i               s              5i 0
      /free
       pathIn = inPath;
       endPos = %len(%trimr(pathIn));
       for i = endPos downto 1;
         if %subst(pathIn:i:1) = '.';
           rtnVal = %subst(pathIn:i+1:endPos-i+1);
           leave;
         endif;
       endfor;

       rtnVal = %xlate(lower:upper:rtnVal);

       return rtnVal;

      /end-free
     P                 E
**ctdata crtnottbl
/EXPNOTES (EN_OBJID CHAR ( 10) NOT NULL WITH
 DEFAULT, EN_SEQNBR CHAR (10 ) NOT NULL WITH DEFAULT, EN_PAGENBR
 CHAR (10 ) NOT NULL WITH DEFAULT, EN_NOTENBR CHAR (10 ) NOT NULL
 WITH DEFAULT, EN_USER CHAR ( 10) NOT NULL WITH DEFAULT, EN_DATE
 CHAR ( 10) NOT NULL WITH DEFAULT, EN_TIME CHAR ( 8) NOT NULL WITH
 DEFAULT, EN_TYPE CHAR ( 30) NOT NULL WITH DEFAULT, EN_ULX CHAR ( 5)
 NOT NULL WITH DEFAULT, EN_ULY CHAR ( 5) NOT NULL WITH DEFAULT,
 EN_LRX CHAR ( 5) NOT NULL WITH DEFAULT, EN_LRY CHAR ( 5) NOT NULL
 WITH DEFAULT, EN_RGB_R1 CHAR ( 3) NOT NULL WITH DEFAULT, EN_RGB_G1
 CHAR ( 3) NOT NULL WITH DEFAULT, EN_RGB_B1 CHAR ( 3) NOT NULL WITH
 DEFAULT, EN_RGB_R2 CHAR ( 3) NOT NULL WITH DEFAULT, EN_RGB_G2 CHAR
 ( 3) NOT NULL WITH DEFAULT, EN_RGB_B2 CHAR ( 3) NOT NULL WITH
 DEFAULT, EN_PATH CHAR ( 512) NOT NULL WITH DEFAULT)
**ctdata csvHeaderA
BatchNumber
Sequence
PageNumber
NoteNumber
User
Date
Time
NoteType
Coord_Upper_Left_X
Coord_Upper_Left_Y
Coord_Lower_Right_X
Coord_Lower_Right_Y
Binary_RGB_Red
Binary_RGB_Grn
Binary_RGB_Blu
Text_RGB_Red
Text_RGB_Grn
Text_RBG_Blu
DiskFileName
**ctdata noteTypesA
hiHIGHLIGHT
snSTICKYNOTE
boBLACKOUT
tnTEXTNOTE
blATTACHMENT
auAUDIO
**ctdata onBaseExtKey
3GP 18
AVI 18
ASD 12
BAT 1
BMP 2
CSV 13
DAT 1
DOC 12
DOCM12
DOCX12
DOTX12
DOT 12
DOTM12
EMF 105
GIF 2
HTML17
HTM 17
ICO 2
ICS 35
INI 1
JPEG2
JPG 2
LST 1
LOG 1
MSG 63
MHT 17
MDI 20
MSO 35
MP4 20
MOV 18
M4A 20
MPEG19
MP3 20
OFT 35
ODT 12
OXPS104
PUB 12
PCX 2
PDF 16
PFF 103
PNG 2
PPS 14
PPSX14
PPT 14
PPTX14
RTF 15
TIFF2
TMP 1
VCF 35
WMV 20
WPS 12
WPA 12
WBK 12
XLW 13
XFD 16
VBS 1
WPD 12
XLSM13
XPS 16
WAV 20
WMZ 20
LNK 17
RPT 1
TXT 1
TIF 2
XFDL41
XLTX13
XLS 13
XLSX13
XLSB1
XLT 13
XML 1
ZIP 70
