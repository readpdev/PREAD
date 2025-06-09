/*      CRTOPT                                                      */
/*      CRTxxx CRTPGM PGM(&O/&N) ENTMOD(MAIN) +                     */
/*      CRTxxx        BNDDIR(SPYSVLSTN) USRPRF(*OWNER)              */
/*---------------------------------------------------------------------------

spysvlstn.c

StaffView Server

Date     Author   Description
-------- -------- ----------------------------------------------
08/18/98 CR       New
---------------------------------------------------------------------------*/

#ifdef __ILEC400__
	#define CITRIX_FIX
	#ifdef CITRIX_FIX
		#include <fcntl.h>
		#include <sys/socket.h>
		#include <sys/types.h>
		#include <sys/time.h>
	#endif
#endif

#include "os.h"
#include "socket.h"
#include "spysvsock.h"
#ifdef INCLUDE_SEO
	#include "StartCase.h"
	#ifndef _AIX
		/* The Vip comm stuff is not ported to UNIX yet */
		#define INCLUDE_SEO_VIP
		/* The tracking stuff is all C++ so don't include it for UNIX
			Note: It is dummied up below to all return successful results */
		#define INCLUDE_SEO_TRACK
		/* Case notes is all C++ ODBC stuff. Don't include in UNIX */
		#define INCLUDE_CASENOTES
	#endif
#endif
#ifdef INCLUDE_SEO_TRACK
	#include "tracksock.h"	/* KLUGE for UNIX */
	#include "trackproc.h"
#endif
#ifdef INCLUDE_IMAGECONV
	#include "tiff2jpeg.h"
#endif
#ifdef INCLUDE_WF
	#include "wfproc.h"
#endif
#ifdef INCLUDE_CASENOTES
	#include "spysvlstn2.h"
#endif
#include "spysvlstn.h"

#ifdef _DEBUG
	#ifndef _AIX
		#define HEAP_CHECK
	#endif
#endif

/* Version History:
	5	Add some parms to SpyGetStartCase()
	6	Add SWSPYPACK_CHGIMGWPID, SWSPYPACK_CHGIMGDOCTYPE, SWSPYPACK_GETCASES
	7	Add WVUCSSTART, WVUCSSTS, WVUSETWPID, Add StaffClass to WVUUPDKEY
	8	1.0.2.0:	Change version number format.
					Invoke child server processes
					Add server control packets
					Add authentication header parsing
	9	1.0.2.0:	Add SWSPYPACK_SERVER_GETINFO version 3 with stats array []
		1.0.2.1:	Fix error and empty pack	t reply version
		1.0.2.3:	Fix some stuff broken in main() during conversion. Call WVUCSSTS with
	10	1.0.2.5:	Remote debugging
	11	1.0.2.6:	Add Staffware TriggerEvent packets (currently takes only one field)
	12	1.0.2.7:	Add SWSPYPACK_GETPENDCASES, SWSPYPACK_PENDCASECONTROL
	12	1.0.2.8:	Attempt to fix SIGSEGV violation in as400.c:SpyGetCases()
	12	1.0.2.9:	Call ENDJOB on unresponsive children at shutdown
	12	1.0.2.10:	Add DOS/WINDOWS mode remote debugging
	14	1.0.2.11:	Add Tiff-to-Jpeg image conversion. Not yet done.
	14	1.0.2.12 1/20/00
		AS400:
			Actually fix SIGSEGV violation in as400.c:SpyGetCases().
			Fix potential bug in char[] buffer overflow with index descriptions.
			This may have been causing odd behaviour or crashing.
			INDEX_DESC_STRLEN was accidentally set to INDEX_NAME_LEN + ...
NOTE: Version 14, I believe, is being shipped with 6.00.05
	15	1.0.2.14 2/11/00
		AS400:
			Add SWSPYPACK_RUNAS400PROG
	15	1.0.2.15 2/25/00
			Overhaul spysvlstn.c Process() routines packet version checking and error
				return. It's been a long time....
			Work around that darn GetPendingRequests heap-corruption/memory-error problem
				On memory error, notify parent we are gone and then exit(1)
	15	1.0.2.16 3/27/00
		AS400:
			Add integer length parm to WVURUNPGM.
			Expect DLL version 5

	15	1.0.2.17 4/23/00
		NT:
			Make SEO login dependency delay configurable
			Misc event log message changes.

	15	1.0.2.18 5/25/00
		NT:
			Change location of StaffViewData to \\staffware_web1...
			Allow "test" to be passed in batch number when viewing image to show
				the  hardcoded image.
	16	1.0.2.19 5/26/00
		NT:
			Use STAFFVIEWDATA environment variable if it is found instead of the
			hardcoded location.
	16	1.0.2.20 6/1/00
		NT:
			Start case using doc class name as description if there is not one so
			cases will start even though "Description Optional" is not flagged.
	16	1.0.2.21 6/2/00
		NT:
			Allow both INCLUDE_SPYNT and INCLUDE_SEO
	17	1.0.3.00 6/00/00
		NT:
			Add SEO session tracking (Track packets)
			Add session tracking modules
			Add server control to send messages and logoff users
	18	1.0.4.00 7/10/00
		NT:
			Add VALIDATEAKEY packet. Fiddle with interal calls to pass more keys
			to UPDATEKEYS and stuff.
	18	1.0.4.01 8/03/00
		AS400:
			Test ValidateAKey
NOTE: Version 18 is being shipped with 6.00.06
	18	1.0.4.02 8/24/00
		All:
			Convert Spy* O/S routines to send and return string arrays
			Functionally, everthing should remain the same (cross your fingers)
	18	1.0.4.03 8/25/00
		NT: Use new *StfVw() routines
		AS400: Return something other than 1 as an error from "Request" routines
	18	1.0.4.4 9/18/00
		NT: Add debug statements for Sander at Heineken
	18	1.0.4.5 9/25/00
		AS400: Don't left justify key fields on update
		NT Java: WIP on the WFPACK_ routines for JAVA
NOTE: Version 18 1.0.4.5 available as a patch to 6.00.06
	18	1.0.4.6 10/16/00
		AS400: Fix memory problem (wonked in 1.0.4.2) in SpyUpdateKeys which
				became apparent in 1.0.4.5
NOTE: Version 18 1.0.4.6 available as a patch to 6.00.06
	19	1.0.5.0 10/23/00
		Java: More WIP on the WFPACK_ routines for JAVA
		Java: Add HTTP Server services and process image requests
		NT: Fix confusion in display and usage between ServerPort and Verbosity
			registry settings (bug)
		AS400: Expect WVU DLL version 6
		AS400: Add SpyGetImageBuf to retrieve image via WVUGETIMG (DLL Version 6 only)
	19	1.0.5.1 11/14/00
		Java: Decode Gauss forms
		Java: Add packet versions in support of new Gauss forms and all that info
		Java: Fix some HTTP problems and test image viewing
		Java: Finish up pretty much for phase I (no Spy key integration)
		NT: Ignore SPY_HOST and SPY_PORT until we get a config option for that
		NT: Support new SEO case key format when looking up case to trigger events
	19	7.0.0.0 11/14/00
		Update version number
	19	7.0.0.1 11/30/00
		AS400: CITRIX changes. Peek packet to validate before doing recv(). See source

 NOTE: Version 1.0.5.3 created on AS400 6.0.6 Patch for KVI. Included only 7.0.0
	for CITRIX
 NOTE: That didn't work so we made a Version 1.0.2.30 on AS400 6.0.6 Base for KV
	for CITRIX
	
	19	7.0.0.2	12/5/00
		NT: Don't attempt to launch HTTP server if StaffViewWeb is not enabled
			(since the check box may still be on for that function, check StaffViewWebEna
	19	7.0.0.3 12/18/00
		AS400: Pass SwConnection by reference to ProcessConnection() so it can clean i
		AS400: Check SwConnection to ensure cleaned up in ProcessConnection()
		NT: Bring into compliance with use of changed ProcessConnection()
		NT: SEO debug messages
	
--- More information from now on is in the RTF file ---
	
	20	7.0.1.0 02/15/01
		ODBC Database support (WorkflowMgr by default)
		[Note: we were going to 7.1.0.0 here but we had to cut short to release 7.0.1.
		NT: VIP Support: Add SWSPYPACK_STARTVIPCASE (54). This will probably be change
			(1/11/1: Include all fields in case start)
		Rename INCLUDE_SPYNT to INCLUDE_SPY
		NT: Return a "DISABLED" error for case start (and all SEO requests)
			if we don't have SEO Spy support enabled
		AS400: Allow lower case in command line parms
		AS400: Fix the aborted child cleanup checking. (Terminated jobs can be in *OUT
			Also, bug in child array cleanup
		WEB: WFPACK_FORM_INFO version 5 (return selected action item index)
		WEB: If action label not overridden then set to "Action"
		WEB: If HTTP services are enabled, then verify that the Spy
			server supports image retrieval. If not, disable HTTP
		NT: Use SPY_HOST and SPY_PORT
		NT: Oops. Don't output debug messages in DebugMsg for release builds
		AS400: Use MSTRCLOGR. Note: Requires MAG103B in the same library.
		WEB: A bunch of WIP for 7.1.0 that will not be used right now
		NT: StaffView Web integration (retrieve image buffer)
		NT: Slightly better handling of case start errors and the event log
		WEB: Minor fixes to protocols/etc to support test app. Also better
			data validation (for test app)
		WEB: WFPACK_FORM_INFO version 7. Return Spy keys
		WEB: Retrieve Spy key information for a form
		WEB: Encode field names with Spy key info
		WEB: Update Spy key info when form saved
		WEB: Fix typo in updating case description when released
		WEB: Get/save user attributes
		NT: Tweak event trigger code for more efficiency (Staffware bug?)
	20	7.1.0.0 03/06/01
		WEB: Convert SAL to SEO
	20	7.1.0.1 03/08/01
		WEB: Finishing touches to 7.1.0.0 SEO stuff
	21	7.1.1.1 04/23/01 Case Notes features
	21	7.1.1.2 04/30/01 Fix Spy/NT 7.1 DLL incompatibility (use new version routine
						 Nope. I was fed erroneous info. Back out this change.
	22	7.1.2.0 05/02/01 Add SWSPYPACK_GETIMAGE version 3 to return image filename
	23	7.1.2.1 07/02/01 Add 506 version 4 to return priority. Custom build for Davi
	24  7.1.2.2 07/09/01
		ALL: Add SWSPYPACK_SERVER_GETPROPS to replace SWSPYPACK_SERVER_GETINFO and
	              send back a property array. Use new PropBlob protocols.
		NT: Add support for new SpyChangeDocType() routine in the Spy API. This
			routine is optional. The existance of this feature is reflected in the
			new Server Properties. Therefore, to use this feature, the new client softwar
			that uses the new properties to determine functionality (specifically SpyView
	24  7.1.2.3 Merit 07/19/01
		WEB: Fix memory leak in retrieving item list
		Cut version for David Merit
	24  7.1.2.3 Curt 07/24/01 Testing
	24  7.1.2.4 Merit 07/30/01
		NT/WEB: Catch (...) for every single ISWCall. Output ERROR to event log
		Cut version for David Merit
	25  7.1.2.5
		NT: Ignore CASESOURCE and CONTENTID from Spy
		VIP: Version 2 of the StartVIPCase protocol for Fujiyama
		WARNING: VIP 5e no longer supported.
	25	7.1.2.6 Still working on this Merit issue
		NT: Set session timeout to 1 hour
		NT: Remove some overly verbose debug messages and add some session debugging
		NT: Remove socket debugging with TRACE_SOCKETS
	25	7.1.2.7 Still working on this Merit issue
		NT: Trap exceptions thrown in Spy/API GetDocInfo()
	25	7.1.2.8 Still working on this Merit issue
		NT: Trap exceptions thrown in all Spy/API calls()
		NT: Add thread ID to log messages
	25	8.0.0.0 Cut a release
	25	8.0.0.1 New Merit issue
	25	8.0.0.3 8.0 Release (see release notes)
	25  8.0.0.4 Merit - Cache host name in SwSpyConnectAuto
	25  8.0.0.5 Merit - Trace messages and try/catch around HTTP image retrieval
	25  8.0.0.6 FITS - Trace messages they didn't need
	25  8.0.0.7 Merit - Properly clean up HTTP thread object
	25	8.0.0.8,9 Bloomberg temporary builds
	25  8.0.1.0 Patch for Historical Notes compatibility with SQL server
	25  8.0.1.2
		AS400: Reply with Job ID to Spy "GENERAL" packet request
		AS400: Always attempt to create debug dataqueue when initializing
			debug to avoid signal trace race conditions
	25  8.0.1.3
		WEB: Version 5 of packet WFPACK_WORKITEM_LIST(506) to return QParam col headin
	26	8.0.2.0
		NT: Add packets SWSPYPACK_ADDMOREKEYS, SWSPYPACK_GETEXTRACASEDATA,
			SWSPYPACK_ADDEXTRACASEDATA, SWSPYPACK_DELEXTRACASEDATA
	27	8.0.2.1
		NT: Add WFPACK_LOGIN Version 3
	27	8.0.2.3
		WEB: Update DocManager key values for VIP ContentExplorer
	27	8.0.2.4
		WEB: Work with newer style spy key specification in SVF file
	27	8.0.2.5
		NT: Fix TrackSession logout
	28	8.0.2.6
		WEB: Properly retrieve $UNDELIVERED workitems under Staffware 8.0
		WEB: Add WFPACK_REFRESH
	28	8.0.2.7
		WEB: Interpret <CR> in multiline comments
		WEB: WFPACK_FORM_INFO version 8,9
	29	8.0.2.8
		WEB: Allow CR/LF or LF in multiline comments
	30	8.0.2.9
		WEB: Add WFPACK_CASE_INFO
*/

#ifdef _DEBUG
	char		Name[] = "SvServiceD";
	char		Version[] = "8.0.2.101D";
	int		VersionNo = 30;
#else
	#ifdef __ILEC400__
		char		Name[] = "SPYSVLSTN";
	#else
		char		Name[] = "SvService";
	#endif
	char		Version[] = "8.0.2.101";
	int		VersionNo = 30;
#endif

/* Statistics */
int			TotalCaseStarts=0;
int			TotalCaseFailures=0;
int			QtyConnectionRequests = 0;
int			QtyPacketRequests = 0;
int			BytesRecv = 0;
int			BytesSent = 0;

int			StandAloneMode=0;
time_t		ShutdownTime = 0;
char		ClientMessage[1024] = "";
extern		char Library[1024];
int			gEnableSpyStaffServ = TRUE;	/* Oops. was FALSE 3/1/1 */


/****************************************************************************
SocketError()

Return a text string showing most recent socket error
****************************************************************************/

char *SocketError()
{
#ifdef WIN32
	return SocketErrorNum(WSAGetLastError());
#else
	return SocketErrorNum(errno);
#endif
}

/****************************************************************************
PrintSwSpyError()
****************************************************************************/

void PrintSwSpyError(char *msg, SwError_t *swerror)
{
	TRACEOUT(ERROR, "%s: %s\n", msg, SwErrorMsg(swerror));
}

/****************************************************************************
MapDocToOmnilink()

***WARNING: THIS ROUTINE HAS NOT BEEN TESTED SINCE CHANGE OVER TO NewStringArray

	Return array of mapped ordinals from document keys to omnilink filters
	NOTE: Caller must initialize Map. Passing a Map already with values is allowed

    Example:
		INVDOC to INVLINK

		Map[0] = -1
		Map[1] = 3
		Map[2] = -1

    This map says that INVDOC second key value is the fourth omnilink
	INVLINK filter.

Return:
	0				Success
	<>0				Error
****************************************************************************/

static int MapDocToOmnilink(const char *DocClass, const char *Omnilink, int Map[
{
	int						i, i2, Error;
	int						QtyOmnilinkIndexes;
	SpyOmnilinkIndexInfo_t	*OmnilinkIndexInfo=NULL;
	char					Description[DOCCLASS_DESC_STRLEN];
	int						QtyIndexes;
	char					SaveOmniKeyName[INDEX_NAME_STRLEN];
	int						OmniKeyOrd;
	int						found;
	char					**IndexNames;
	char					**IndexDescs;
	int						*IndexLens;

	/* Get document key names */

	if (Error = SpyGetDocInfo(DocClass, Description, &QtyIndexes, &IndexNames, &Ind
		TRACEOUT(ERROR, "Error retrieving document information: %d\n", Error);
		return Error;
	}

	/* Get omnilink information */

	TRACEOUT(NORMAL, "Getting omnilink info for %s\n", Omnilink);
	if (Error = SpyGetOmnilinkInfo(
		Omnilink,
		&QtyOmnilinkIndexes,
		&OmnilinkIndexInfo)) {
		TRACEOUT(ERROR, "Error retrieving omnilink %s: %d\n", Omnilink, Error);
		return Error;
	}

	/* Scan omnilink spylinks looking for this document class.
	   Set map ordinals from image key values as they are found */

	/* This SaveOmniKeyName thing is a kluge we use to figure out the
	   omnilink filter index since we don't have that directly. What we
	   have is an array of omniindex names which may be duplicates.
	   Fortunately, they are in order. */

	strcpy(SaveOmniKeyName, "bogus");
	OmniKeyOrd = -1;	/* Always increments first time */
	for (i=0; i<QtyOmnilinkIndexes; i++) {
		
		/* There are keys defined with omnilink name. Check out why */

		if (OmnilinkIndexInfo[i].OmniIndexName[0] == '\0') {
			continue;
		}
		if (strcmp(OmnilinkIndexInfo[i].OmniIndexName, SaveOmniKeyName)) {
			strcpy(SaveOmniKeyName, OmnilinkIndexInfo[i].OmniIndexName);
			OmniKeyOrd++;
		}
		if (strcmp(OmnilinkIndexInfo[i].DocClass, DocClass) == 0) {
			/* Found spylink to our document class */
			/* Lookup doc key name */
			found = FALSE;
			for (i2=0; i2<QtyIndexes; i2++) {
				if (strcmp(IndexNames[i2], OmnilinkIndexInfo[i].SpyIndex) == 0) {
					/* Found document key */
					Map[i2] = OmniKeyOrd;
					found = TRUE;
					break;
				}
			}
			if (! found) {
				TRACEOUT(ERROR, "Unable to find spy key %s\n",
					OmnilinkIndexInfo[i].SpyIndex);
			}
		}
	}

	DeleteSpyOmnilinkInfo(&OmnilinkIndexInfo, QtyOmnilinkIndexes);
	FreeStringArray(&IndexNames);
	FreeStringArray(&IndexDescs);
	free(IndexLens);

	return 0;
}

/****************************************************************************
ValidatePacket()
	Validate packet is the correct type and version. Send error response
	back to user if necessary.

These odd return values aid in keeping calling code simple:
	1				Success
	0				Failure
	-1				Socket error
****************************************************************************/

int ValidatePacket(SwConnection_t *SwConnection, int PacketType, int MinVersion,
{
	if (SwConnection->header.type != PacketType) {
		TRACEOUT(ERROR, "Unexpected packet %d. Expected %d\n",
			SwConnection->header.type, PacketType);
		assert(0);
	}

	if ((SwConnection->header.version < MinVersion) ||
		(SwConnection->header.version > MaxVersion)) {
		/* Probably a newer version of the client */
		TRACEOUT(ERROR, "Unrecognized packet %d version: %d\n",
			SwConnection->header.type,
			SwConnection->header.version);
		if (SwSpySendError(
				SwConnection,
				SWSPYERR_BADPACKVERS,
				SwConnection->header.version,
				SwError) < 0) {
			return -1;
		}
		return 0;
	}
	return 1;
}

#ifdef INCLUDE_SEO_VIP
/****************************************************************************
ProcessStartVIPCase()
	Start a Staffware Case

Pass Data:
	SwConnection	A connection containing a packet

Packet Layout:

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessStartVIPCase(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*CaseDesc = "";
	char			*ProcName;
	char			*Step;
	char			*oidurl, *subtitle, *topicname, *websitename, *approveemail;
	char			*rejectemail, *Host;
	__int32			Port, objectdepth, objectvers;
	char			*cp, *cp1, *cp2, *cpt1, *cpt2;
	char			*contentid;
	char			*FieldNames = NULL;
	char			*FieldValues = NULL;
	__int32			QtyFields = 0;
	int				i, Result, Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_STARTVIPCASE, 2, 2, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetNewStrFromBuf(data, &ProcName);
	data += GetNewStrFromBuf(data, &Step);	
	data += GetNewStrFromBuf(data, &CaseDesc);	
	data += GetNewStrFromBuf(data, &contentid);
	data += GetNewStrFromBuf(data, &oidurl);	
	data += GetNewStrFromBuf(data, &subtitle);	
	data += GetNewStrFromBuf(data, &topicname);	
	data += GetNewStrFromBuf(data, &websitename);	
	data += GetNewStrFromBuf(data, &approveemail);	
	data += GetNewStrFromBuf(data, &rejectemail);	
	data += GetNewStrFromBuf(data, &Host);		
	data += GetInt32FromBuf(data, &Port);		
	data += GetInt32FromBuf(data, &objectdepth);		
	data += GetInt32FromBuf(data, &objectvers);		

	data += GetInt32FromBuf(data, &QtyFields);			/* int32 */
	/* safety check before malloc */
	if ((QtyFields < 0) || (QtyFields > 200)) {
		TRACEOUT(VERBOSE, "Bad quantity of fields in packet: %d\n", QtyFields);
		return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
	}

	FieldNames = data;									/* char[][] */
	/* Do EBCDIC conversion */
	for (i=0; i<QtyFields; i++) {
		data += GetNewStrFromBuf(data, &cp);
	}

	FieldValues = data;									/* char[][] */
	/* Do EBCDIC conversion */
	for (i=0; i<QtyFields; i++) {
		data += GetNewStrFromBuf(data, &cp);
	}

	/* --- Debug output */
	if (*Step) {
		TRACEOUT(NORMAL, "Start VIP case %s on Step %s for OID %s\n",
					ProcName, Step, contentid);
	} else {
		TRACEOUT(NORMAL, "Start VIP case %s for OID %s\n",
					ProcName, contentid);
	}
	TRACEOUT(VERBOSE, "Description='%s'\n", CaseDesc);
	TRACEOUT(VERBOSE, "URL=%s\n", oidurl);
	TRACEOUT(VERBOSE, "Subtitle=%s, topicname=%s\n", subtitle, topicname);
	TRACEOUT(VERBOSE, "website=%s\n", websitename);
	TRACEOUT(VERBOSE, "approve=%s, reject=%s\n", approveemail, rejectemail);
	TRACEOUT(VERBOSE, "Depth=%d, Vers=%d\n", objectdepth, objectvers);
	/* --- Debug output */

	cp1 = FieldNames;
	cp2 = FieldValues;
	for (i=0; i<QtyFields; i++) {
		cp1 += GetNewStrFromBuf(cp1, &cpt1);
		cp2 += GetNewStrFromBuf(cp2, &cpt2);
		TRACEOUT(VERBOSE, "Field '%s'='%s'\n", cpt1, cpt2);
	}

	if (*Step) {
		if (SwSpySendError(
				SwConnection,
				SWSPYERR_NOTSUPPORTED,
				SwConnection->header.version,
				SwError) < 0) {
			PrintSwSpyError("Error sending error packet", SwError);
			return -1;
		}
		return 0;
	}

	Result = StartVIPCase(ProcName, Step, CaseDesc, contentid, oidurl, subtitle, to
			websitename, approveemail, rejectemail, Host, Port, objectdepth, objectvers,
				QtyFields, FieldNames, FieldValues);
	if (Result == 0) {
		TotalCaseStarts++;
	} else {
		TotalCaseFailures++;
	}

	switch (Result) {
		case 0:
			return SwSpySendEmptyReply(SwConnection, SwError);
		case SWCASE_INIT:
			return SwSpySendError(SwConnection, SWSTAFFERR_INIT, 0, SwError);
		case SWCASE_LOGIN:
			return SwSpySendError(SwConnection, SWSTAFFERR_LOGIN, 0, SwError);
		case SWCASE_START:
			return SwSpySendError(SwConnection, SWSTAFFERR_STARTCASE, 0, SwError);
	}
	TRACEOUT(VERBOSE, "Unknown case start response\n");
	return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
}
#endif /*INCLUDE_SEO_VIP*/


#ifdef INCLUDE_SEO
/****************************************************************************
ProcessStartCase()
	Start a Staffware Case

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	char[]			Procedure Name
	char[]			Start Step

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessStartCase(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*DocClass;
	char			*BatchNo;
	__int32			ImageSeqNo;
	char			*CaseDesc = "";
	char			*StafflinkClass = "";
	__int32			wpid = 0;
	char			*ProcName;
	char			*Step;
	char			*cp, *cp1, *cp2;
	char			*FieldNames = NULL;
	char			*FieldValues = NULL;
	__int32			StartPage = 0;
	__int32			EndPage = 0;
	__int32			QtyFields = 0;
	int				i, Result, Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_STARTSPYCASE, 1, 3, SwError
		return Error;
	}

	data = SwConnection->data;

	if (SwConnection->header.version >= 3) {
		data += GetStrFromBuf(data, &StafflinkClass);		/* char[] */
		data += GetInt32FromBuf(data, &wpid);				/* int32 */
	}
	
	data += GetStrFromBuf(data, &DocClass);					/* char[] */	
	data += GetStrFromBuf(data, &BatchNo);					/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);				/* int32 */

	if (SwConnection->header.version >= 2) {
		data += GetInt32FromBuf(data, &StartPage);			/* int32 */
		data += GetInt32FromBuf(data, &EndPage);			/* int32 */
		data += GetInt32FromBuf(data, &QtyFields);			/* int32 */
		/* safety check before malloc */
		if ((QtyFields < 0) || (QtyFields > 400)) {
			TRACEOUT(VERBOSE, "Bad quantity of fields in packet: %d\n", QtyFields);
			return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
		}

		FieldNames = data;									/* char[][] */
		/* Do EBCDIC conversion */
		for (i=0; i<QtyFields; i++) {
			data += GetStrFromBuf(data, &cp);
		}

		FieldValues = data;									/* char[][] */
		/* Do EBCDIC conversion */
		for (i=0; i<QtyFields; i++) {
			data += GetStrFromBuf(data, &cp);
		}
		data += GetStrFromBuf(data, &CaseDesc);				/* char[] */
	}
	
	data += GetStrFromBuf(data, &ProcName);					/* char[] */
	data += GetStrFromBuf(data, &Step);						/* char[] */

	/* --- Debug output */
	if (*Step) {
		TRACEOUT(NORMAL, "Start case of %s on Step %s for %s:%s-%d (page %d/%d)\n",
					ProcName, Step, DocClass, BatchNo, ImageSeqNo, StartPage,EndPage);
	} else {
		TRACEOUT(NORMAL, "Start case of %s for %s:%s-%d (page %d/%d)\n",
					ProcName, DocClass, BatchNo, ImageSeqNo, StartPage, EndPage);
	}
	TRACEOUT(VERBOSE, "Stafflink '%s' WPID %d\n", StafflinkClass, wpid);
	TRACEOUT(VERBOSE, "Description='%s'\n", CaseDesc);
	/* --- Debug output */

	cp1 = FieldNames;
	cp2 = FieldValues;
	TRACEOUT(VERBOSE, "Qty Fields: %d\n", QtyFields);
	for (i=0; i<QtyFields; i++) {
		TRACEOUT(VERBOSE, "Field '%s'='%s'\n", cp1, cp2);
		cp1 += GetStrFromBuf(cp1, &cp);
		cp2 += GetStrFromBuf(cp2, &cp);
	}

	Result = StartCase(StafflinkClass, wpid, DocClass, BatchNo, ImageSeqNo,
				StartPage, EndPage, QtyFields, FieldNames, FieldValues, CaseDesc, Step,
				ProcName);
	if (Result == 0) {
		TotalCaseStarts++;
	} else {
		TotalCaseFailures++;
	}

	switch (Result) {
		case 0:
			return SwSpySendEmptyReply(SwConnection, SwError);
		case SWCASE_INIT:
			return SwSpySendError(SwConnection, SWSTAFFERR_INIT, 0, SwError);
		case SWCASE_LOGIN:
			return SwSpySendError(SwConnection, SWSTAFFERR_LOGIN, 0, SwError);
		case SWCASE_START:
			return SwSpySendError(SwConnection, SWSTAFFERR_STARTCASE, 0, SwError);
	}
	TRACEOUT(VERBOSE, "Unknown case start response\n");
	return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
}

/****************************************************************************
ProcessTriggerEvent()
	Trigger a staffware event

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]		Case reference
	char[]		Event name
	int32		Number of fields
	char[][]	Field names
	char[][]	Field Values

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessTriggerEvent(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*CaseRef;
	char			*EventName;
	char			*cp;
	char			*FieldNames = NULL;
	char			*FieldValues = NULL;
	__int32			QtyFields = 0;
	int				i, Error, Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_TRIGGEREVENT, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &CaseRef);			/* char[] */
	data += GetStrFromBuf(data, &EventName);		/* char[] */
	data += GetInt32FromBuf(data, &QtyFields);		/* int32 */
	/* safety check before malloc */
	if ((QtyFields < 0) || (QtyFields > 200)) {
		TRACEOUT(VERBOSE, "Bad quantity of fields in packet: %d\n", QtyFields);
		return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
	}

	FieldNames = data;								/* char[][] */
	/* Do EBCDIC conversion */
	for (i=0; i<QtyFields; i++) {
		data += GetStrFromBuf(data, &cp);
		TRACEOUT(VERBOSE, "Name='%s'\n", cp);
	}

	FieldValues = data;								/* char[][] */
	/* Do EBCDIC conversion */
	for (i=0; i<QtyFields; i++) {
		data += GetStrFromBuf(data, &cp);
		TRACEOUT(VERBOSE, "Value='%s'\n", cp);
	}

	TRACEOUT(NORMAL, "Trigger event %s: %s\n", CaseRef, EventName);

	Result = TriggerEvent(
				CaseRef,
				EventName,
				QtyFields,
				FieldNames,
				FieldValues);
	switch (Result) {
		case 0:
			return SwSpySendEmptyReply(SwConnection, SwError);
		case SWCASE_EVENT:
			return SwSpySendError(SwConnection, SWSTAFFERR_TRIGGEREVENT, 0, SwError);
	}
	return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
}

/****************************************************************************
ProcessCloseCase()
	Close a Staffware Case

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Procedure Name
	int32			Case Number

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessCloseCase(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*ProcName;
	__int32			CaseNumber;
	int				Result, Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CLOSECASE, 1, 1, SwError))
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &ProcName);			/* char[] */
	data += GetInt32FromBuf(data, &CaseNumber);		/* int32 */

	TRACEOUT(NORMAL, "Close Case %s-%d\n", ProcName, CaseNumber);

	Result = CloseCase(ProcName, CaseNumber);

	/* !! Look at StartCase for SWCASE_ error messages */

	if (Result == 0) {
		return SwSpySendEmptyReply(SwConnection, SwError);
	}
	return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
}
#endif	/*INCLUDE_SEO*/

#ifdef INCLUDE_IMAGECONV
/****************************************************************************
ProcessConvertImage()
	Begin image conversion. This will be followed by image data and a
	convert call.

Pass Data:
	SwConnection	A connection containing am image conversion request packet

Packet Layout:
	int32			From image type (1=TIFF)
	int32			To image type (2=JPG)
	int32			Smoothing (0-100. -1=use default)
	int32			Quality (0-100. -1=use default)
	int32			Image size
	char[]			Image buffer

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessConvertImage(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*ImageData;
	int				ImageSize;
	int				FromType;
	int				ToType;
	int				Smoothing;
	int				Quality;
	int				Error;
	char			*NewImage;
	int				NewImageSize;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CONVERTIMAGE, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetInt32FromBuf(data, &FromType);		/* int32 */
	data += GetInt32FromBuf(data, &ToType);			/* int32 */
	data += GetInt32FromBuf(data, &Smoothing);		/* int32 */
	data += GetInt32FromBuf(data, &Quality);		/* int32 */
	data += GetInt32FromBuf(data, &ImageSize);		/* int32 */
	ImageData = data;								/* buffer[] */

	/* Validate sent data */

	if ((FromType != 1) &&
		(ToType != 2)) {			/* This should not happen */
		return SwSpySendError(SwConnection, SWIMGERR_CONVERT, 1, SwError);
	}

	/* Convert the image */

	TRACEOUT(VERBOSE, "Converting image (%d bytes). Smoothing=%d, Quality=%d\n",
				ImageSize, Smoothing, Quality);

	if (Error = ConvertTiff2Jpeg(ImageData, ImageSize, Smoothing, Quality, &NewImag
		TRACEOUT(ERROR, "Error converting image: %d\n", Error);
		FreeImageBuf(NewImage);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	Error = SwSpySendConvertedImage(SwConnection, NewImage, NewImageSize, SwError);
	FreeImageBuf(NewImage);
	return Error;
}
#endif

/****************************************************************************
ProcessUpdateKeys()
	Update keys and return result. Pretty much like ValidateKeys

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	int32			Number of keys
	char[][]		Key Values

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessUpdateKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32			numkeys;
	char			*data, *cp;
	char			*DocClass;
	char			*StaffClass="";
	char			*BatchNo;
	int				ImageSeqNo;
	int				i, Error;
	char			**IndexValues;
	int				*IndexStatus;
	int				Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_UPDATEKEYS, 1, 2, SwError))
		return Error;
	}

	data = SwConnection->data;

	if (SwConnection->header.version >= 2) {
		data += GetStrFromBuf(data, &StaffClass);	/* char[] */	
	}

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */

	TRACEOUT(NORMAL, "Updating keys for %s,%s:%s-%d\n",
		StaffClass,
		DocClass,
		BatchNo,
		ImageSeqNo);

	data += GetInt32FromBuf(data, &numkeys);		/* int32 */
	TRACEOUT(VERBOSE, "Keys: %d\n", numkeys);

	IndexValues = NewStringArray(numkeys);
	IndexStatus = NewIntArray(numkeys);

	if ((IndexValues == NULL) ||
		(IndexStatus == NULL)) {
		Error = DBMEM;
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Do EBCDIC conversion */
	for (i=0; i<numkeys; i++) {						/* char[][] */
		data += GetStrFromBuf(data, &cp);
		IndexValues[i] = strdup(cp);
		TRACEOUT(VERBOSE, "Key %d: %s\n", i+1, IndexValues[i]);
	}

	/* Update Keys */

	if (Error = SpyUpdateKeys(StaffClass, DocClass, BatchNo, ImageSeqNo, numkeys, I
		TRACEOUT(ERROR, "Error updating keys: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	for (i=0; i<numkeys; i++) {
		if (IndexStatus[i]) {
			TRACEOUT(VERBOSE, "Key %d status is %d\n", i, IndexStatus[i]);
		}
	}

	Result = SwSpySendUpdateKeys(SwConnection, numkeys, IndexStatus, SwError);

	/* WARNING: This will be a memory leak if we get an error. These need to be fre
		the return SwSpySendError(), above */
	FreeStringArray(&IndexValues);
	free(IndexStatus);

	return Result;
}

/****************************************************************************
ProcessGetKeys()
	Return key values

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessGetKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32			numkeys;
	char			*data;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			**NewValues;
	int				i, Error, Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETKEYS, 1, 1, SwError)) <
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */

	/* Retrieve keys */

	TRACEOUT(NORMAL, "Getting keys for %s:%s-%d\n",
		DocClass,
		BatchNo,
		ImageSeqNo);

	if (Error = SpyGetKeys(DocClass, BatchNo, ImageSeqNo, &numkeys, &NewValues)) {
		TRACEOUT(ERROR, "Error retrieving key values information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* --- Debug output */
	for (i=0; i<numkeys; i++) {
		TRACEOUT(VERBOSE, "Result Key %d: %s\n", i+1, NewValues[i]);
	}
	/* --- Debug output */

	Result = SwSpySendGetKeys(SwConnection, numkeys, NewValues, SwError);

	FreeStringArray(&NewValues);

	return Result;
}

/****************************************************************************
ProcessValidateKeys()
	Validate keys and return validated and formatted values

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	int32			Number of keys
	char[][]		Key Values

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessValidateKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32			numkeys;
	char			*data, *cp;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	int				i, Error;
	char			**IndexValues = NULL;
	char			**NewValues = NULL;
	char			**ErrorMsgs = NULL;
	int				*KeyStatus = NULL;
	int				Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_VALIDATEKEYS, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */

	TRACEOUT(NORMAL, "Validating keys for %s:%s-%d\n",
		DocClass,
		BatchNo,
		ImageSeqNo);

	data += GetInt32FromBuf(data, &numkeys);		/* int32 */
	TRACEOUT(VERBOSE, "Keys: %d\n", numkeys);

	/* Validate Keys */

#if 1
	IndexValues = NewStringArray(numkeys);
	if (IndexValues == NULL) {
		Error = DBMEM;
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	TRACEOUT(VERBOSE, "After...\n");
#endif

#if 0
	Error = DBMEM;
	return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwEr
#endif

	for (i=0; i<numkeys; i++) {						/* char[][] */
		/* Do EBCDIC conversion */
		data += GetStrFromBuf(data, &cp);
		if ((IndexValues[i] = strdup(cp)) == NULL) {
			Error = DBMEM;
			return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, Sw
		}
		TRACEOUT(VERBOSE, "Key %d: %s\n", i+1, IndexValues[i]);
	}

	if (Error = SpyValidateKeys(DocClass, BatchNo, ImageSeqNo, numkeys, IndexValues
		TRACEOUT(ERROR, "Error retrieving document information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* --- Debug output */
	for (i=0; i<numkeys; i++) {
		TRACEOUT(VERBOSE, "Result Key %d: %d - %s\n", i+1, KeyStatus[i], NewValues[i])
	}
	/* --- Debug output */

	Result = SwSpySendValidatedKeys(SwConnection, numkeys, NewValues, KeyStatus, Sw

	FreeStringArray(&NewValues);
	FreeStringArray(&ErrorMsgs);
	
	/* Terry Bayne 10/27/04 */
	FreeStringArray(&IndexValues);
	
	free(KeyStatus);

	return Result;
}

/****************************************************************************
ProcessValidateAKey()
	Validate a key and return validated and formatted value

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	int32			Key Number
	char[]			Key Value

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessValidateAKey(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32			keyno;
	char			*data;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			*IndexValue;
	char			NewValue[INDEX_VAL_STRLEN];
	char			ErrorMsg[INDEX_ERRORMSG_STRLEN];
	__int32			keystatus;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_VALIDATEAKEY, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */

	data += GetInt32FromBuf(data, &keyno);			/* int32 */

	data += GetStrFromBuf(data, &IndexValue);		/* char[] */

	TRACEOUT(NORMAL, "Validating key %d for %s:%s-%d (%s)\n",
		keyno,
		DocClass,
		BatchNo,
		ImageSeqNo,
		IndexValue);

#ifdef __ILEC400__
	if (keyno >= 7) {
		TRACEOUT(ERROR, "Key index out of range: %d\n", keyno);
		return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, 0, SwError);
	}
#endif

	if (Error = SpyValidateAKey(DocClass, BatchNo, ImageSeqNo, keyno, IndexValue, N
		TRACEOUT(ERROR, "Error retrieving document information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	TRACEOUT(VERBOSE, "Result Key %d: %d (%s)\n", keyno, keystatus, NewValue);

	return SwSpySendValidateAKey(SwConnection, keyno, NewValue, keystatus, SwError)
}


/****************************************************************************
ProcessCaseClosed()
	Update Spy that case is closed

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Stafflink Class
	int32			Work packet ID
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	int32			Reason
	char[]			Case Number

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessCaseClosed(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*StaffClass;
	int				wpid;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			*caseno;
	__int32			reason;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CASECLOSED, 2, 2, SwError))
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &StaffClass);		/* char[] */
	data += GetInt32FromBuf(data, &wpid);			/* int32 */
	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetInt32FromBuf(data, &reason);			/* int32 */
	data += GetStrFromBuf(data, &caseno);			/* char[] */

	/* Notify that case is closed */

	TRACEOUT(VERBOSE, "Case %s closed for (wp:%s-%d) %s:%s-%d\n",
				caseno,
				StaffClass,
				wpid,
				DocClass,
				BatchNo,
				ImageSeqNo);

	if (Error = SpyCaseClosed(StaffClass, wpid, DocClass, BatchNo, ImageSeqNo, case
		TRACEOUT(ERROR, "Error flagging case as closed: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	return SwSpySendEmptyReply(SwConnection, SwError);
}

/****************************************************************************
ProcessCaseStarted()
	Update Spy with image's workflow case number

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Stafflink Class
	int32			Work packet ID
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	char[]			Case Number

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessCaseStarted(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*StaffClass;
	int				wpid;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			*caseno;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CASESTARTED, 2, 2, SwError)
		return Error;
	}
	
	data = SwConnection->data;

	data += GetStrFromBuf(data, &StaffClass);		/* char[] */
	data += GetInt32FromBuf(data, &wpid);			/* int32 */
	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetStrFromBuf(data, &caseno);			/* char[] */

	/* Notify case started */

	TRACEOUT(VERBOSE, "Case %s started for (wp:%s-%d) %s:%s-%d\n",
				caseno,
				StaffClass,
				wpid,
				DocClass,
				BatchNo,
				ImageSeqNo);

	if (Error = SpyCaseStarted(StaffClass, wpid, DocClass, BatchNo, ImageSeqNo, cas
		TRACEOUT(ERROR, "Error flagging case as started: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	return SwSpySendEmptyReply(SwConnection, SwError);
}


/****************************************************************************
ProcessDocInfo()
	Return DocInfo data to client

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document Class Name	

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessDocInfo(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data, *doctype;
	char			Description[DOCCLASS_DESC_STRLEN];
	int				QtyIndexes;
	int				i, Error;
	int				Result;
	char			**IndexNames;
	char			**IndexDescs;
	int				*IndexLens;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETDOCINFO, 1, 2, SwError))
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &doctype);			/* char[] */

	/* Retrieve document information */

	TRACEOUT(NORMAL, "Returning information for document class '%s'\n", doctype);

	if (Error = SpyGetDocInfo(doctype, Description, &QtyIndexes, &IndexNames, &Inde
		TRACEOUT(ERROR, "Error retrieving document information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* --- Debug output */
	TRACEOUT(NORMAL, "Document Class Description: %s\n", Description);
	TRACEOUT(NORMAL, "Qty Keys: %d\n", QtyIndexes);
	for (i=0; i<QtyIndexes; i++) {
		TRACEOUT(VERBOSE, "Key %d Length %d: %s\n", i+1, IndexLens[i], IndexNames[i]);
	}
	/* --- Debug output */

	Result = SwSpySendDocInfo(SwConnection, Description, QtyIndexes, IndexNames, In

	FreeStringArray(&IndexNames);
	FreeStringArray(&IndexDescs);
	free(IndexLens);

	return Result;
}


/****************************************************************************
ProcessOmnilinks()

***WARNING: THIS ROUTINE HAS NOT BEEN TESTED SINCE CHANGE OVER TO NewStringArray

    Return list of omnilinks to client

Pass Data:
	SwConnection	A connection containing a omnilink info packet

Packet Layout:
	char[]			Document Class Name

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessOmnilinks(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char				*data, *doctype;
	char				*OmniNames=NULL;
	char				*OmniDescs=NULL;
	int					QtyOmnilinks;
	SpyOmnilinkNames_t	*OmnilinkNames=NULL;
	char				*cpNames, *cpDescs;
	int					i, len, Error;
	int					NamesLen;
	int					DescsLen;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETOMNILINKS, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &doctype);			/* char[] */

	/* Get OmniLinks */

	TRACEOUT(NORMAL, "Returning omnilinks for document class '%s'\n", doctype);

	if (Error = SpyGetOmnilinks(doctype, &QtyOmnilinks, &OmnilinkNames)) {
		TRACEOUT(ERROR, "Error retrieving omnilinks: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	TRACEOUT(NORMAL, "Qty Omnilinks: %d\n", QtyOmnilinks);

	if (QtyOmnilinks == 0) {
		Error = SwSpySendOmniLinks(
				SwConnection,
				0,
				"",
				"",
				SwError);
	} else {

		/* Copy names the hard way */

		NamesLen = 0;
		DescsLen = 0;
		for (i=0; i<QtyOmnilinks; i++) {
			NamesLen += strlen(OmnilinkNames[i].OmnilinkName) + 1;
			DescsLen += strlen(OmnilinkNames[i].OmnilinkDesc) + 1;
			TRACEOUT(VERBOSE, "Omnilink %s: %s\n",
				OmnilinkNames[i].OmnilinkName,
				OmnilinkNames[i].OmnilinkDesc);
		}

		OmniNames = malloc(NamesLen);
		OmniDescs = malloc(DescsLen);

		cpNames = OmniNames;
		cpDescs = OmniDescs;
		for (i=0; i<QtyOmnilinks; i++) {
			len = strlen(OmnilinkNames[i].OmnilinkName) + 1;
			memcpy(cpNames, OmnilinkNames[i].OmnilinkName, len);
			cpNames += len;

			len = strlen(OmnilinkNames[i].OmnilinkDesc) + 1;
			memcpy(cpDescs, OmnilinkNames[i].OmnilinkDesc, len);
			cpDescs += len;
		}

		Error = SwSpySendOmniLinks(
				SwConnection,
				QtyOmnilinks,
				OmniNames,
				OmniDescs,
				SwError);

		free(OmniNames);
		free(OmniDescs);
	}
	
	DeleteSpyOmnilinkNames(&OmnilinkNames, QtyOmnilinks);

	if (Error < 0) {
		return -1;
	}
	return 0;
}

/****************************************************************************
ProcessRelatedDocs()
	
***WARNING: THIS ROUTINE HAS NOT BEEN TESTED SINCE CHANGE OVER TO NewStringArray

	Return list of document classes to client

Pass Data:
	SwConnection	A connection containing a relateddocs packet

Packet Layout:
	char[]			Document Class Name

Return:
	0				Success
	-1				Error
****************************************************************************/

typedef struct
{
	char	docclass[DOCCLASS_DESC_STRLEN];
	int		strlenplus1;
} omnidoc_t;

int ProcessRelatedDocs(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char					*data, *doctype;
	char					*OmniNames=NULL;
	int						QtyOmnilinks;
	SpyOmnilinkNames_t		*OmnilinkNames=NULL;
	int						QtyOmnilinkIndexes;
	SpyOmnilinkIndexInfo_t	*OmnilinkIndexInfo=NULL;
	int						i, i2, j, Error;
	omnidoc_t				*omnidocs;
	int						qtyomnidocs;
	char					**ReturnDocs;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETRELATEDDOCS, 1, 1, SwErr
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &doctype);			/* char[] */

	TRACEOUT(NORMAL, "Returning related documents for document class '%s'\n", docty

	if (Error = SpyGetOmnilinks(doctype, &QtyOmnilinks, &OmnilinkNames)) {
		TRACEOUT(ERROR, "Error retrieving omnilinks: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	TRACEOUT(NORMAL, "Qty Omnilinks: %d\n", QtyOmnilinks);

	if (QtyOmnilinks == 0) {
		Error = SwSpySendRelatedDocs(
				SwConnection,
				0,
				NULL,
				SwError);
	} else {
		omnidocs = NULL;
		qtyomnidocs = 0;

		for (i=0; i<QtyOmnilinks; i++) {

			/* Get document classes in each omnilink */

			if (Error = SpyGetOmnilinkInfo(
				OmnilinkNames[i].OmnilinkName,
				&QtyOmnilinkIndexes,
				&OmnilinkIndexInfo)) {
				TRACEOUT(ERROR, "Error retrieving omnilink %s: %d\n",
					OmnilinkNames[i].OmnilinkName, Error);
				continue;
			}
			
			TRACEOUT(NORMAL, "Qty docs in omnilink %s: %d\n",
				OmnilinkNames[i].OmnilinkName,
				QtyOmnilinkIndexes);

			for (i2=0; i2<QtyOmnilinkIndexes; i2++) {
				TRACEOUT(VERBOSE, "Omnilink %s index %d: %s. Doc=%s, index=%s\n",
					OmnilinkNames[i].OmnilinkName,
					i2,
					OmnilinkIndexInfo[i2].OmniIndexName,
					OmnilinkIndexInfo[i2].DocClass,
					OmnilinkIndexInfo[i2].SpyIndex);
				/* Look for duplicates */
				for (j=0; j<qtyomnidocs; j++) {
					if (memcmp(
							OmnilinkIndexInfo[i2].DocClass,
							omnidocs[j].docclass,
							omnidocs[j].strlenplus1) == 0) {
						break;
					}
				}
				/* Not yet in list. Add */
				if (j== qtyomnidocs) {
					omnidocs = realloc(omnidocs, (qtyomnidocs + 1) * sizeof(omnidoc_t));
					strcpy(omnidocs[j].docclass, OmnilinkIndexInfo[i2].DocClass);
					omnidocs[j].strlenplus1 = strlen(OmnilinkIndexInfo[i2].DocClass) + 1;
					qtyomnidocs++;
				}
			}
			DeleteSpyOmnilinkInfo(&OmnilinkIndexInfo, QtyOmnilinkIndexes);
		}

		/* Move omnidocs list into return buffer */

		ReturnDocs = NewStringArray(qtyomnidocs);

		for (i=0; i<qtyomnidocs; i++) {
			ReturnDocs[i] = strdup(omnidocs[i].docclass);
		}
			
		Error = SwSpySendRelatedDocs(SwConnection, qtyomnidocs, ReturnDocs, SwError);

		FreeStringArray(&ReturnDocs);
		free(omnidocs);
	}
	
	DeleteSpyOmnilinkNames(&OmnilinkNames, QtyOmnilinks);

	if (Error < 0) {
		return -1;
	}
	return 0;
}

/****************************************************************************
ProcessOmniKeys()

***WARNING: THIS ROUTINE HAS NOT BEEN TESTED SINCE CHANGE OVER TO NewStringArray

	Return mapped keys from document keys to omnilink filters

Pass Data:
	SwConnection	A connection containing a relateddocs packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	char[]			Omnilink Name

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessOmniKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32					numkeys;
	char					*data;
	char					*DocClass;
	char					*BatchNo;
	int						ImageSeqNo;
	char					*Omnilink;
	char					**NewValues, **OmniMappedValues;
	int						i, Error;
	SpyOmnilinkIndexInfo_t	*OmnilinkIndexInfo=NULL;
	int						Map[INDEX_COUNT];
	int						Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETOMNIKEYS, 1, 1, SwError)
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetStrFromBuf(data, &Omnilink);			/* char[] */

	TRACEOUT(NORMAL, "Getting omnilink %s keys for %s:%s-%d\n",
		Omnilink,
		DocClass,
		BatchNo,
		ImageSeqNo);

	/* Get image key values */

	if (Error = SpyGetKeys(DocClass, BatchNo, ImageSeqNo, &numkeys, &NewValues)) {
		TRACEOUT(ERROR, "Error retrieving key values information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Get Omnilink Filter Map */

	for (i=0; i<INDEX_COUNT; i++) {
		Map[i] = -1;
	}
	if (Error = MapDocToOmnilink(DocClass, Omnilink, Map)) {
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	OmniMappedValues = NewStringArray(INDEX_COUNT);

	for (i=0; i<INDEX_COUNT; i++) {
		if (Map[i] != -1) {
			OmniMappedValues[Map[i]] = strdup(NewValues[i]);
		}
	}
	/* Safety: fill unfilled slots */
	for (i=0; i<INDEX_COUNT; i++) {
		if (OmniMappedValues[i] == NULL) {
			OmniMappedValues[i] = strdup("");
		}
	}

	Result = SwSpySendOmnilinkKeys(SwConnection, INDEX_COUNT, OmniMappedValues, SwE

	FreeStringArray(&NewValues);
	/* Terry Bayne 10/27/04 */
	FreeStringArray(&OmniMappedValues);

	return Result;
}

/****************************************************************************
ProcessRelatedKeys()

***WARNING: THIS ROUTINE HAS NOT BEEN TESTED SINCE CHANGE OVER TO NewStringArray

	Return mapped keys from one document's keys to another via omnilinks

Pass Data:
	SwConnection	A connection containing a relateddocs packet

Packet Layout:
	char[]			From Document class
	char[]			Batch ID
	int32			Image Sequence Number
	char[]			To Document Class

Return:
	0				Success
	-1				Error
****************************************************************************/

#ifdef USE_OMNILINKS_FOR_RELATIONSHIP

int ProcessRelatedKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	__int32			numkeys;
	char			*data;
	char			*FromDocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			*ToDocClass;
	char			**NewValues;
	char			ToKeys[INDEX_COUNT][INDEX_VAL_STRLEN];
	int				io, i, j, Error;
	int				FromDocMap[INDEX_COUNT];
	int				ToDocMap[INDEX_COUNT];
	int				QtyOmnilinks;
	SpyOmnilinkNames_t	*OmnilinkNames=NULL;
	int				Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETRELATEDKEYS, 1, 1, SwErr
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &FromDocClass);			/* char[] */	
	data += GetStrFromBuf(data, &BatchNo);				/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);			/* int32 */
	data += GetStrFromBuf(data, &ToDocClass);			/* char[] */

	TRACEOUT(NORMAL, "Getting related keys from %s:%s-%d to %s\n",
		FromDocClass,
		BatchNo,
		ImageSeqNo,
		ToDocClass);

	/* Get image key values */

	if (Error = SpyGetKeys(FromDocClass, BatchNo, ImageSeqNo, &numkeys, &NewValues)
		TRACEOUT(ERROR, "Error retrieving key values information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Loop through all omnilinks */
	/* It is going to be just as slow to create an omnilink list relating
	   the two document classes as just going ahead and trying them all */

	if (Error = SpyGetOmnilinks(FromDocClass, &QtyOmnilinks, &OmnilinkNames)) {
		TRACEOUT(ERROR, "Error retrieving omnilinks: %d\n", Error);
		FreeStringArray(&NewValues);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	TRACEOUT(NORMAL, "Qty Omnilinks: %d\n", QtyOmnilinks);

	memset(ToKeys, 0, sizeof(ToKeys));

	for (io=0; io<QtyOmnilinks; io++) {
		TRACEOUT(VERBOSE, "Omnilink %s: %s\n",
			OmnilinkNames[io].OmnilinkName,
			OmnilinkNames[io].OmnilinkDesc);

		/* Get From-Doc Omnilink Filter Map */

		for (i=0; i<INDEX_COUNT; i++) {
			FromDocMap[i] = -1;
		}
		if (Error = MapDocToOmnilink(
						FromDocClass,
						OmnilinkNames[io].OmnilinkName,
						FromDocMap)) {
			FreeStringArray(&NewValues);
			return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, Sw
		}

		/* Get To-Doc Omnilink Filter Map */

		for (i=0; i<INDEX_COUNT; i++) {
			ToDocMap[i] = -1;
		}
		if (Error = MapDocToOmnilink(
						ToDocClass,
						OmnilinkNames[io].OmnilinkName,
						ToDocMap)) {
			FreeStringArray(&NewValues);
			return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, Sw
		}

		for (i=0; i<INDEX_COUNT; i++) {
			if (FromDocMap[i] != -1) {
				for (j=0; j<INDEX_COUNT; j++) {
					if (FromDocMap[i] == ToDocMap[j]) {
						strcpy(ToKeys[j], NewValues[i]);
					}
				}
			}
		}
	} /*for(;;)*/

	FreeStringArray(&NewValues);

	NewValues = NewStringArray(INDEX_COUNT);

	for (i=0; i<INDEX_COUNT; i++) {
		NewValues[i] = strdup(ToKeys[i]);
	}

	Result = SwSpySendRelatedKeys(SwConnection, INDEX_COUNT, NewValues, SwError);

	FreeStringArray(&NewValues);

	return Result;
}
#else /*USE_OMNILINKS*/
int ProcessRelatedKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*FromDocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	char			*ToDocClass;
	int				i, j, Error;
	__int32			numkeys;
	int				QtyKey1, QtyKey2;
	char			**KeyValues1;
	char			**KeyValues2;
	char			DummyDesc[DOCCLASS_DESC_STRLEN];
	char			**KeyNames1, **KeyNames2;
	char			**KeyDescs1, **KeyDescs2;
	int				*KeyLens1, *KeyLens2;
	int				Result;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETRELATEDKEYS, 1, 1, SwErr
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &FromDocClass);		/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetStrFromBuf(data, &ToDocClass);		/* char[] */

	TRACEOUT(NORMAL, "Getting related keys from %s:%s-%d to %s\n",
		FromDocClass,
		BatchNo,
		ImageSeqNo,
		ToDocClass);

	/* Get image key values */

	if (Error = SpyGetKeys(FromDocClass, BatchNo, ImageSeqNo, &numkeys, &KeyValues1
		TRACEOUT(ERROR, "Error retrieving key values information: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Get doc class information #1 */

	if (Error = SpyGetDocInfo(FromDocClass, DummyDesc, &QtyKey1, &KeyNames1, &KeyDe
		TRACEOUT(ERROR, "Error retrieving doc class info: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Get doc class information #2 */

	if (Error = SpyGetDocInfo(ToDocClass, DummyDesc, &QtyKey2, &KeyNames2, &KeyDesc
		TRACEOUT(ERROR, "Error retrieving doc class info: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	KeyValues2 = NewStringArray(QtyKey2);

	for (i=0; i<QtyKey2; i++) {
		for (j=0; j<QtyKey1; j++) {
			if (strcmp(KeyNames2[i], KeyNames1[j]) == 0) {
				KeyValues2[i] = strdup(KeyValues1[j]);
			}
		}
	}

	/* safety: fill unfilled slots */

	for (i=0; i<QtyKey2; i++) {
		if (KeyValues2[i] == NULL) {
			KeyValues2[i] = strdup("");
		}
	}

	Result = SwSpySendRelatedKeys(SwConnection, QtyKey2, KeyValues2, SwError);

	FreeStringArray(&KeyValues1);
	FreeStringArray(&KeyNames1);
	FreeStringArray(&KeyDescs1);
	free(KeyLens1);
	FreeStringArray(&KeyValues2);
	FreeStringArray(&KeyNames2);
	FreeStringArray(&KeyDescs2);
	free(KeyLens2);

	return Result;
}

#endif /*USE_OMNILINKS */

/****************************************************************************
ProcessChangeImageWpid()
	Update Spy image wpid, if it has one

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	int32			New wpid

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessChangeImageWpid(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	int				wpid;
	char			*DocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CHGIMGWPID, 1, 1, SwError))
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetInt32FromBuf(data, &wpid);			/* int32 */

	TRACEOUT(VERBOSE, "Changing wpid for %s:%s-%d to %d\n",
				DocClass,
				BatchNo,
				ImageSeqNo,
				wpid);

	if (Error = SpyChangeWpid(DocClass, BatchNo, ImageSeqNo, wpid)) {
		TRACEOUT(ERROR, "Error changing wpid: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	return SwSpySendEmptyReply(SwConnection, SwError);
}

/****************************************************************************
ProcessChangeImageDocType()
	Update Spy image wpid, if it has one

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]			Document class
	char[]			Batch number
	int32			Image sequence number
	char[]			New document class

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessChangeImageDocType(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data, *cpdata;
	char			*DocClass;
	char			*NewDocClass;
	char			*BatchNo;
	int				ImageSeqNo;
	__int32			numkeys;
	char			*IndexValues;
	int				i;
	char			*cp;
	char			NewBatchNo[10];
	int				NewImageSeqNo;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_CHGIMGDOCTYPE, 1, 1, SwErro
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* char[] */
	data += GetStrFromBuf(data, &BatchNo);			/* char[] */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* int32 */
	data += GetStrFromBuf(data, &NewDocClass);		/* char[] */

	TRACEOUT(VERBOSE, "Changing doctype for %s:%s-%d to %s\n",
				DocClass,
				BatchNo,
				ImageSeqNo,
				NewDocClass);

	/* int32 */
	data += GetInt32FromBuf(data, &numkeys);
	if ((numkeys > 999) || (numkeys < 0)) {
		TRACEOUT(ERROR, "Invalid number of keys: %d\n", numkeys);
		return -1;
	}
	TRACEOUT(VERBOSE, "Keys: %d\n", numkeys);

	/* char[][] */
	cpdata = data;	/* Retain data to pass to fn() */
	IndexValues = cpdata;
	/* Do EBCDIC conversion */
	for (i=0; i<numkeys; i++) {
		cpdata += GetStrFromBuf(cpdata, &cp);
		TRACEOUT(VERBOSE, "Key %d: %s\n", i+1, cp);
	}

	if (Error = SpyChangeDocType(DocClass, BatchNo, ImageSeqNo, NewDocClass, numkey
		TRACEOUT(ERROR, "Error changing doc class: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	TRACEOUT(NORMAL, "New image is %s:%s-%d\n", NewDocClass, NewBatchNo, NewImageSe

	return SwSpySendChgDocType(SwConnection, NewBatchNo, NewImageSeqNo, SwError);
}

/****************************************************************************
ProcessGetCases()
	Return list of matching cases

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]		Stafflink class
	char[]		Case start beginning date
	char[]		Case start ending date
	int			State (0x1=Open, 0x2=Closed)
	int			Number search filters
	char[][]	Search filter 1..n

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessGetCases(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*StaffClass;
	char			*StartDate;
	char			*EndDate;
	char			*Filter1;
	char			*Filter2;
	char			*Filter3;
	char			*Filter4;
	int				State;
	int				QtyFilters;
	int				QtyCases;
	int				QtyCasesReturned;
	SpyCases_t		*SpyCases;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETCASES, 1, 2, SwError)) <
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &StaffClass);		/* char[] */
	data += GetStrFromBuf(data, &StartDate);		/* char[] */
	data += GetStrFromBuf(data, &EndDate);			/* char[] */
	data += GetInt32FromBuf(data, &State);			/* int32 */
	data += GetInt32FromBuf(data, &QtyFilters);		/* int32 */
	/*KLUGE*/
	if (QtyFilters != 4) {
		if (SwSpySendError(
				SwConnection,
				SWSPYERR_NOTSUPPORTED,
				SwConnection->header.version,
				SwError) < 0) {
			PrintSwSpyError("Error sending error packet", SwError);
			return -1;
		}
		return 0;
	}
	data += GetStrFromBuf(data, &Filter1);		/* char[] */
	data += GetStrFromBuf(data, &Filter2);		/* char[] */
	data += GetStrFromBuf(data, &Filter3);		/* char[] */
	data += GetStrFromBuf(data, &Filter4);		/* char[] */

	TRACEOUT(NORMAL, "Open cases for %s (from '%s'-'%s'), State %d, Filters %d\n",
		StaffClass,
		StartDate,
		EndDate,
		State,
		QtyFilters);

	TRACEOUT(NORMAL, "Filters: 1='%s'  2='%s'  3='%s'  4='%s'\n",
		Filter1, Filter2, Filter3, Filter4);

	if (Error = SpyGetCases(
					StaffClass,
					Filter1,	
					Filter2,	
					Filter3,	
					Filter4,	
					StartDate,
					EndDate,
					State,
					&QtyCases,
					&QtyCasesReturned,
					&SpyCases)) {
		TRACEOUT(ERROR, "Error retrieving cases: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}
	
	TRACEOUT(NORMAL, "Qty Cases: %d, Returned: %d\n", QtyCases, QtyCasesReturned);
	Error = SwSpySendCases(SwConnection, QtyCases, QtyCasesReturned, SpyCases, SwEr
	DeleteSpyCases(&SpyCases, QtyCasesReturned);
	return Error;
}

/****************************************************************************
ProcessGetDebugMsgs()
	Return next n debug messages

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	int				Flags
	unsigned long	ClientIP
	int				Qty messages requested

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessGetDebugMsgs(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	int				QtyMsgs;
	int				Flags;
	unsigned long	ClientIP;
	SpyDebugMsg_t	*SpyDebugMsgs;
	int				Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETDEBUGMSGS, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetInt32FromBuf(data, &Flags);				/* int32 */
	data += GetInt32FromBuf(data, (int *)&ClientIP);	/* int32 */
	data += GetInt32FromBuf(data, &QtyMsgs);			/* int32 */

	/* Avoid race condition reading debug messages and adding at same time */
	/* TRACEOUT(NORMAL, "Retrieve next %d messages\n", QtyMsgs); */

	if (Error = SpyGetDebugMsgs(
					ClientIP,
					&QtyMsgs,
					&SwConnection->NextMessage,
					&SpyDebugMsgs)) {
		TRACEOUT(ERROR, "Error retrieving debug messages: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE
	}

	/* Avoid race condition reading debug messages and adding at same time */
	/* TRACEOUT(NORMAL, "Qty debug messages found: %d\n", QtyMsgs); */

	Error = SwSpySendDebugMsgs(SwConnection, QtyMsgs, SpyDebugMsgs, SwError);
	DeleteSpyDebugMsgs(&SpyDebugMsgs, QtyMsgs);
	return Error;
}


/****************************************************************************
ProcessInitDebug()
	Initialize for remote debugging

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	int			Level
	char[]		User

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessInitDebug(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	int				Level, Error;
	char			*UserName;
	char			Buf[50];
#ifdef __ILEC400__
	char			command[200];
#endif

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_INITDEBUG, 1, 1, SwError))
		return Error;
	}

	data = SwConnection->data;

	data += GetInt32FromBuf(data, &Level);	/* int32 */
	data += GetStrFromBuf(data, &UserName);	/* char[] */

	TRACEOUT(NORMAL, "Initialize debug for: %s, level %d\n", UserName, Level);

	/* Don't allow in standalone mode because it doesn't disconnect and we
	   can't block our own debug messages from logging */
	if (StandAloneMode) {
		TRACEOUT(ERROR, "Debug mode disallowed in standalone mode\n");
		return SwSpySendError(SwConnection, SWSPYERR_DISABLED, SwConnection->header.ty
	}
	
#ifdef __ILEC400__
	/* Avoid signal trap which does debug output which apparently tries to write to
	   debug queue or some such thing. Just always try to create it */
	sprintf(command, "CRTDTAQ DTAQ(%s/%s) MAXLEN(250) SEQ(*FIFO) TEXT('StaffView De
		Library,
		DEFAULT_DEBUGQUEUE);
	system(command);

	if (ClearDebugQueue() < 0) {
		TRACEOUT(ALWAYS, "Attempting to create data queue SPYSVDBG\n");
		sprintf(command, "CRTDTAQ DTAQ(%s/%s) MAXLEN(250) SEQ(*FIFO) TEXT('StaffView D
			Library,
			DEFAULT_DEBUGQUEUE);
		TRACEOUT(ALWAYS, "%s\n", command);
		system(command);
		/* Try again */
		if (ClearDebugQueue() < 0) {
			return SwSpySendError(SwConnection, SWSPYERR_FAILED, SwConnection->header.typ
		}
		SetRemoteDebugMode(ALWAYS);
		TRACEOUT(ALWAYS, "Debug Queue %s Created\n", DEFAULT_DEBUGQUEUE);
	}
#endif

	/* One trace message so we see we are actually tracing if there is little activ
	SetRemoteDebugMode(ALWAYS);
	TRACEOUT(ALWAYS, "Start Remote Tracing\n");

	/* This is as good a place as any. Don't debug the process that is
	   asking for debug messages or we will get loopy */
	SetRemoteDebugMode(NODEBUG);
	if (SwSpySendInitDebug(SwConnection, 0, "", SwError) < 0) {
		PrintSwSpyError("Error sending packet", SwError);
		/* Don't bother to fail here */
	}
	/* Tell server our user name and new debug level */
	sprintf(Buf, "%d,%s", Level, UserName);
#ifdef __ILEC400__
	if (WriteMainQueue(QUEUECMD_IAM_REMOTEDEBUG, Buf, strlen(Buf) + 1, PARENT_NOTIF
		TRACEOUT(ERROR, "Error writing STARTED to queue\n");
	}
#else
	SetRemoteDebugMode(Level);
#endif
	SwConnection->DebugInitialized = TRUE;
	return 0;
}

/****************************************************************************
ProcessGetPendCases()
	Return list of matching cases

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	char[]		Stafflink class
	char[]		Case start beginning date
	char[]		Case start ending date
	int			State (0x1=Open, 0x2=Closed)
	int			Number search filters
	char[][]	Search filter 1..n

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessGetPendCases(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char				*data;
	char				*Type;
	int					Qty;
	int					QtyReturned;
	SpyPendRequest_t	*Requests;
	int					Error;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETPENDCASES, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &Type);			/* char[] */

	/* Get Pending Requests */

	TRACEOUT(NORMAL, "Pending requests of type %s\n", Type);

	if (Error = SpyGetPendRequests(
					Type,
					&Qty,
					&QtyReturned,
					&Requests)) {
		TRACEOUT(ERROR, "Error retrieving requests: %d\n", Error);

#ifdef __ILEC400__
	#define BAIL_BECAUSE_HEAP_IS_CORRUPT
#endif

#ifdef BAIL_BECAUSE_HEAP_IS_CORRUPT
		if (Error < 0) {
			SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwError);
			TRACEOUT(ERROR, "Exiting with corrupt heap\n");
#ifdef __ILEC400__
			if (WriteMainQueue(QUEUECMD_STOPPED, NULL, 0, PARENT_NOTIFICATION_KEY) < 0) {
				TRACEOUT(ERROR, "Error writing STOPPED to queue\n");
			}
#endif
			exit(1);
		}
#endif
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error), Error, SwE

	}

	TRACEOUT(NORMAL, "Qty pending requests: %d, %d\n", Qty, QtyReturned);
	Error = SwSpySendPendRequests(SwConnection, Qty, QtyReturned, Requests, SwError
	DeleteSpyPendRequests(&Requests, QtyReturned);

	TRACEOUT(VERBOSE, "Pending requests sent\n");
	return Error;
}

/****************************************************************************
ProcessPendCaseControl()
	Perform requested pending case control operation

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	int			Operation (SVPENDCASECONTROL_*)
	char[]		New Status (Used only for SVPENDCASECONTROL_STATUS)
	int			Number of IDs (zero=all)
	Array of:
		int			MSTFREQ Record ID

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessPendCaseControl(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char				*data;
	int					Operation;
	int					Qty;
	int					*RecordIDArray=NULL;
	char				*NewStatus;
	int					Error, i;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_PENDCASECONTROL, 1, 1, SwEr
		return Error;
	}

	data = SwConnection->data;

	data += GetInt32FromBuf(data, &Operation);		/* int32 */
	data += GetStrFromBuf(data, &NewStatus);		/* char[] */
	data += GetInt32FromBuf(data, &Qty);			/* int32 */
	if (Qty) {
		RecordIDArray = (int *)malloc(Qty * sizeof(int));
	}
	for (i=0; i<Qty; i++) {
		/* int32: Level */
		data += GetInt32FromBuf(data, &RecordIDArray[i]);
	}

	TRACEOUT(NORMAL, "Pending request control %d for %d requests\n", Operation, Qty

	switch (Operation) {
		case SVPENDCASECONTROL_STATUS:
			Error = SpyPendRequestStatus(Qty, RecordIDArray, NewStatus);
			break;
		case SVPENDCASECONTROL_RETRY:
			Error = SpySubmitPendRequest(Qty, RecordIDArray);
			break;

		case SVPENDCASECONTROL_DELETE:
			Error = SpyDelPendRequest(Qty, RecordIDArray);
			break;
		default:
			if (RecordIDArray) {
				free(RecordIDArray);
			}
			return SwSpySendError(SwConnection, SWSPYERR_UNKNOWN, SwConnection->header.ve
	}

	if (Error) {
		TRACEOUT(ERROR, "Error performing pending request control: %d\n", Error);
		if (RecordIDArray) {
			free(RecordIDArray);
		}
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error),	Error, SwE
	}
	if (RecordIDArray) {
		free(RecordIDArray);
	}
	return SwSpySendEmptyReply(SwConnection, SwError);
}

/****************************************************************************
ProcessRunAS400Prog()
	Return list of matching cases

Pass Data:
	SwConnection	A connection containing one of these packets

Packet Layout:
	char[]		library name
	char[]		program name
	int			Number of parms to pass
	int[]		Length of parms (as passed into AS400 program buffer)
	char[][]	Parms to pass
	int			Number of parms to return
	int[]		Length of return parms (as returned from AS400 program buffer)

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessRunAS400Prog(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char				*data;
	char				*LibName, *ProgName;
	int					QtyPassParms;
	int					PassParmLens[100];	/* kluge */
	char				*PassParms;
	int					QtyRtnParms;
	int					RtnParmLens[100];	/* kluge */
	char				*RtnParms;
	int					Error;
	int					i;
	char				*cp;

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_RUNAS400PROG, 1, 1, SwError
		return Error;
	}

	data = SwConnection->data;

	data += GetStrFromBuf(data, &LibName);					/* char[] */
	data += GetStrFromBuf(data, &ProgName);					/* char[] */
	data += GetInt32FromBuf(data, &QtyPassParms);			/* int32 */
	for (i=0; i<QtyPassParms; i++) {
		data += GetInt32FromBuf(data, &PassParmLens[i]);	/* int32 */
	}

	PassParms = data;										/* char[][] */
	TRACEOUT(VERBOSE, "Parms pass=%d\n", QtyPassParms);
	/* Do EBCDIC conversion */
	for (i=0; i<QtyPassParms; i++) {
		data += GetStrFromBuf(data, &cp);
		TRACEOUT(VERBOSE, "Parm %d (len %d): %s\n", i+1, PassParmLens[i], cp);
	}

	data += GetInt32FromBuf(data, &QtyRtnParms);			/* int32 */
	TRACEOUT(VERBOSE, "Parms rtn=%d\n", QtyRtnParms);
	/* Do EBCDIC conversion */
	for (i=0; i<QtyRtnParms; i++) {
		data += GetInt32FromBuf(data, &RtnParmLens[i]);		/* int32 */
	}

	/* Run the program */

	for (i=0; i<QtyRtnParms; i++) {
		TRACEOUT(VERBOSE, "Expecting return parm %d length: %d\n", i+1, RtnParmLens[i]
	}

	TRACEOUT(NORMAL, "Run AS400 program: %s/%s\n", LibName, ProgName);

	if (Error = SpyRunAS400Prog(
					LibName, ProgName,
					QtyPassParms, PassParmLens, PassParms,
					QtyRtnParms, RtnParmLens, &RtnParms)) {
		TRACEOUT(ERROR, "Error running AS400 program: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error),	Error, SwE
	}

	Error = SwSpySendRunAS400Prog(
			SwConnection,
			QtyRtnParms,
			RtnParms,
			SwError);
	DeleteSpyRunAS400ProgParms(&RtnParms);
	return Error;
}
/****************************************************************************
ProcessGetImage()
	Return the image

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout:
	NewString		Document class
	NewString		Batch number
	int32			Image sequence number
	int32			StartPage
	int32			EndPage

Return:
	0				Successfully processed packet. Error may have been sent to client
	-1				Fatal packet processing error (Socket, bad checksum, etc). Close connecti
****************************************************************************/

int ProcessGetImage(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*data;
	char			*DocClass, *BatchNo;
	__int32			StartPage, EndPage, ImageSeqNo;
	int				Error, Result;
	char			*ImageBuf = NULL;
	int				Length;
	char			ImageFileName[256];

	/* Validate packet and session */

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_GETIMAGE, 2, 3, SwError)) <
		return Error;
	}

	/* Decode packet data */

	data = SwConnection->data;

	data += GetStrFromBuf(data, &DocClass);			/* String */
	data += GetStrFromBuf(data, &BatchNo);			/* String */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* Int32 */
	data += GetInt32FromBuf(data, &StartPage);		/* Int32 */
	data += GetInt32FromBuf(data, &EndPage);		/* Int32 */

	TRACEOUT(VERBOSE, "Image requested: %s/%s-%d (%d/%d)\n", DocClass, BatchNo, Ima

	/* Get Image */

	if (Error = SpyGetImageBuf(DocClass, BatchNo, ImageSeqNo, StartPage, EndPage, &
		TRACEOUT(ERROR, "Error retrieving image: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error),	Error, SwE
	}

	TRACEOUT(VERBOSE, "Returning image (%d bytes)\n", Length);
	Result = SwSpySendImage(SwConnection, ImageBuf, Length, 0, ImageFileName, SwErr
	/* Eeek! Added this in 7.1.2 (5/1/1) */
	if (ImageBuf) { /* Safety */
		free(ImageBuf);
	}
	return Result;
}

/****************************************************************************
ProcessAddMoreKeys()

Pass Data:
	SwConnection	A connection containing a docinfo packet

Packet Layout (Version 1):
1	NewString		DocClass
1	NewString		BatchNo
1	int32			ImageSeqNo
1	int32			Number of keys
	Array of:
1		NewString		Key Value

Return:
	0				Success
	-1				Error
****************************************************************************/

int ProcessAddMoreKeys(SwConnection_t *SwConnection, SwError_t *SwError)
{
	char			*cp, *data;
	char			*DocClass, *BatchNo;
	__int32			ImageSeqNo;
	int				i, numkeys, Error;
	char			**IndexValues;

	/* Validate packet and session */

	if ((Error = ValidatePacket(SwConnection, SWSPYPACK_ADDMOREKEYS, 1, 1, SwError)
		return Error;
	}

	/* Decode packet data */

	data = SwConnection->data;

	data += GetNewStrFromBuf(data, &DocClass);			/* String */
	data += GetNewStrFromBuf(data, &BatchNo);			/* String */
	data += GetInt32FromBuf(data, &ImageSeqNo);		/* Int32 */
	TRACEOUT(VERBOSE, "Add MoreKeys: %s/%s-%d\n", DocClass, BatchNo, ImageSeqNo);

	data += GetInt32FromBuf(data, &numkeys);		/* int32 */

	IndexValues = NewStringArray(numkeys);
	
	/* Do EBCDIC conversion */
	for (i=0; i<numkeys; i++) {						/* char[][] */
		data += GetNewStrFromBuf(data, &cp);
		IndexValues[i] = strdup(cp);
		TRACEOUT(VERBOSE, "Key %d: %s\n", i+1, IndexValues[i]);
	}

	/* Add MoreKeys */

	if (Error = SpyAddMoreKeyValues("", DocClass, BatchNo, ImageSeqNo, numkeys, Ind
		TRACEOUT(ERROR, "Error adding more keys: %d\n", Error);
		return SwSpySendError(SwConnection, SwSpyXlateDatabaseError(Error),	Error, SwE
	}
	/* Terry Bayne 10/27/04 */
	FreeStringArray(&IndexValues);
	return SwSpySendEmptyReply(SwConnection, SwError);
}

/****************************************************************************
ProcessConnection()
	Handle a newly connected client

Pass Data:
	SwConnection	A new client connection

Return:
	0				Success (done)
	-1				Error
****************************************************************************/

int ProcessConnection(SwConnection_t **pSwConnection)
{
	SwError_t		SwError;
	BOOL			done = FALSE;
	int				result = 0;
	SwConnection_t	*SwConnection = *pSwConnection;
#ifdef CITRIX_FIX
	fd_set			readfds;
	struct timeval	timeout;
#endif
#ifdef HEAP_CHECK
		int				heapsize = GetUsedHeapBytes();
#endif

#if defined(WIN32) && !defined (NTSERVICE)
	TRACEOUT(ALWAYS, "\n");
#endif

#ifdef _DEBUG
	TRACEOUT(ALWAYS, "DEBUG BUILD! Processing new connection...\n");
#else
	TRACEOUT(VERBOSE, "Processing new client connection...\n");
#endif

#ifdef HEAP_CHECK
	/* I haven't had any problems, but doesn't hurt to check */
	/* TRACEOUT(ALWAYS, "Checking heap...\n"); */
	{
		int theapsize = GetUsedHeapBytes();

		if (theapsize < 0) {
			TRACEOUT(ERROR, "Heap corrupt!\n");
		} else {
			TRACEOUT(ALWAYS, "Heap size: %d Kb (%d bytes)\n", theapsize/1024, theapsize);
		}
	}
#endif

	SwConnection->DebugInitialized = FALSE;
	while (! done) {

#ifdef CITRIX_FIX
		FD_ZERO(&readfds);
		FD_SET(SwConnection->fd, &readfds);
		timeout.tv_sec = 5;
		timeout.tv_usec = 0;
		result = select(32, &readfds, 0, 0, &timeout);
		if (result < 0) {
			TRACEOUT(ERROR, "Error selecting socket (%d)\n", errno);
			result = 0;
			goto DONE;
		}
		if (result == 0) {
			TRACEOUT(ERROR, "Client didn't close connection. Punting...\n");
			result = 0;
			goto DONE;
		}
#endif

		if (SwSpyRecvPacket(SwConnection, &SwError) < 0) {
			if (SwErrorIsConnectionClosed(&SwError)) {
				TRACEOUT(VERBOSE, "Closing client connection\n");
				result = 0;
				goto DONE;
			}
			PrintSwSpyError("Error receiving packet", &SwError);
			result = -2;
			goto DONE;
		}

		result = 0;
		/* This only works under NT. We are in a different process on AS/400 */
		QtyPacketRequests++;
		/* This only works under NT. We are in a different process on AS/400 */
		switch(SwConnection->header.type) {
#ifdef INCLUDE_WF
			case WFPACK_LOGIN:
				result = ProcessWfLogin(SwConnection, &SwError);
				break;
			case WFPACK_LOGOUT:
				result = ProcessWfLogout(SwConnection, &SwError);
				break;
			case WFPACK_GETUSERSETTINGS:
				result = ProcessWfGetUserSettings(SwConnection, &SwError);
				break;
			case WFPACK_SAVEUSERSETTINGS:
				result = ProcessWfSaveUserSettings(SwConnection, &SwError);
				break;
			case WFPACK_QUEUE_LIST:
				result = ProcessWfQueueList(SwConnection, &SwError);
				break;
			case WFPACK_CASE_INFO:
				result = ProcessWfCaseInfo(SwConnection, &SwError);
				break;
			case WFPACK_WORKITEM_LIST:
				result = ProcessWfWorkitemList(SwConnection, &SwError);
				break;
			case WFPACK_WORKITEM_INFO:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
			case WFPACK_KEEPCASE:
				result = ProcessWfKeepCase(SwConnection, &SwError);
				break;
			case WFPACK_FORM_INFO:
				result = ProcessWfFormInfo(SwConnection, &SwError);
				break;
			case WFPACK_GETIMAGEINFO:
				result = ProcessWfGetImageInfo(SwConnection, &SwError);
				break;
			case WFPACK_GETIMAGEPAGE:
				result = ProcessWfGetImagePage(SwConnection, &SwError);
				break;
			case WFPACK_KEEPALIVE:
				result = ProcessWfKeepAlive(SwConnection, &SwError);
				break;
			case WFPACK_SPYLOGIN:
				result = ProcessWfSpyLogin(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_LISTTEMPLATES:
				result = ProcessWfActiveListTemplates(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_GETTEMPLATE:
				result = ProcessWfActiveGetTemplate(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_LISTFILES:
				result = ProcessWfActiveListFiles(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_GETFILE:
				result = ProcessWfActiveGetFile(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_PUTFILE:
				result = ProcessWfActivePutFile(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_DELFILE:
				result = ProcessWfActiveDelFile(SwConnection, &SwError);
				break;
			case WFPACK_ACTIVE_UPLOAD:
				result = ProcessWfActiveUpload(SwConnection, &SwError);
				break;
			case WFPACK_DOCCLASSINFO:
				result = ProcessWfDocClassInfo(SwConnection, &SwError);
				break;
			case WFPACK_REFRESH:
				result = ProcessWfRefresh(SwConnection, &SwError);
				break;
#else
			case WFPACK_LOGIN:
			case WFPACK_LOGOUT:
			case WFPACK_GETUSERSETTINGS:
			case WFPACK_SAVEUSERSETTINGS:
			case WFPACK_QUEUE_LIST:
			case WFPACK_CASE_INFO:
			case WFPACK_WORKITEM_LIST:
			case WFPACK_WORKITEM_INFO:
			case WFPACK_KEEPCASE:
			case WFPACK_FORM_INFO:
			case WFPACK_GETIMAGEINFO:
			case WFPACK_GETIMAGEPAGE:
			case WFPACK_KEEPALIVE:
			case WFPACK_SPYLOGIN:
			case WFPACK_ACTIVE_LISTTEMPLATES:
			case WFPACK_ACTIVE_GETTEMPLATE:
			case WFPACK_ACTIVE_LISTFILES:
			case WFPACK_ACTIVE_GETFILE:
			case WFPACK_ACTIVE_PUTFILE:
			case WFPACK_ACTIVE_DELFILE:
			case WFPACK_ACTIVE_UPLOAD:
			case WFPACK_DOCCLASSINFO:
			case WFPACK_REFRESH:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif /*! INCLUDE_WF*/

#ifdef INCLUDE_IMAGECONV
			case SWSPYPACK_CONVERTIMAGE:
				result = ProcessConvertImage(SwConnection, &SwError);
				break;
#else
			case SWSPYPACK_CONVERTIMAGE:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif /*! INCLUDE_IMAGECONV*/

#ifdef INCLUDE_SEO
			case SWSPYPACK_STARTSPYCASE:
				if (gEnableSpyStaffServ) {
					result = ProcessStartCase(SwConnection, &SwError);
				} else {
					result = SwSpySendError(SwConnection, SWSPYERR_DISABLED, SwConnection->head
				}
				break;
			case SWSPYPACK_CLOSECASE:
				if (gEnableSpyStaffServ) {
					result = ProcessCloseCase(SwConnection, &SwError);
				} else {
					result = SwSpySendError(SwConnection, SWSPYERR_DISABLED, SwConnection->head
				}
				break;
			case SWSPYPACK_TRIGGEREVENT:
				if (gEnableSpyStaffServ) {
					result = ProcessTriggerEvent(SwConnection, &SwError);
				} else {
					result = SwSpySendError(SwConnection, SWSPYERR_DISABLED, SwConnection->head
				}
				break;
#else
			case SWSPYPACK_STARTSPYCASE:
			case SWSPYPACK_CLOSECASE:
			case SWSPYPACK_TRIGGEREVENT:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif /*! INCLUDE_SEO*/

#ifdef INCLUDE_SEO_VIP
			case SWSPYPACK_STARTVIPCASE:
				if (gEnableSpyStaffServ) {
					result = ProcessStartVIPCase(SwConnection, &SwError);
				} else {
					result = SwSpySendError(SwConnection, SWSPYERR_DISABLED, SwConnection->head
				}
				break;
#else
			case SWSPYPACK_STARTVIPCASE:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif

#ifdef INCLUDE_CASENOTES
			case SWSPYPACK_GETCASENOTES:
				result = ProcessGetCaseNotes(SwConnection, &SwError);
				break;
			case SWSPYPACK_ADDCASENOTE:
				result = ProcessAddCaseNote(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETEXTRACASEDATA:
				result = ProcessGetExtraCaseData(SwConnection, &SwError);
				break;
			case SWSPYPACK_ADDEXTRACASEDATA:
				result = ProcessAddExtraCaseData(SwConnection, &SwError);
				break;
			case SWSPYPACK_DELEXTRACASEDATA:
				result = ProcessDelExtraCaseData(SwConnection, &SwError);
				break;
#else
			case SWSPYPACK_GETCASENOTES:
			case SWSPYPACK_ADDCASENOTE:
			case SWSPYPACK_GETEXTRACASEDATA:
			case SWSPYPACK_ADDEXTRACASEDATA:
			case SWSPYPACK_DELEXTRACASEDATA:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif

#ifdef INCLUDE_SEO_TRACK
			case TRACKPACK_LOGIN:
				result = ProcessSVTrackingLogin(SwConnection, &SwError);
				break;
			case TRACKPACK_LOGOUT:
				result = ProcessSVTrackingLogout(SwConnection, &SwError);
				break;
			case TRACKPACK_SESSIONSTATUS:
				result = ProcessSVTrackingStatus(SwConnection, &SwError);
				break;
#else
#ifdef UNIX_KLUGE
			/* KLUGE for UNIX: Return GOOD results */
			case TRACKPACK_LOGIN:
				result = SVTrackingSendLogin(SwConnection, 0, "1234567890123456", "", &SwErr
				break;
			case TRACKPACK_LOGOUT:
				result = SwSpySendEmptyReply(SwConnection, &SwError);
				break;
			case TRACKPACK_SESSIONSTATUS:
				result = SVTrackingSendStatus(SwConnection, -1, "", &SwError);
				break;
#else
			case TRACKPACK_LOGIN:
			case TRACKPACK_LOGOUT:
			case TRACKPACK_SESSIONSTATUS:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif
#endif /*INCLUDE_SEO_TRACK*/

#if defined(INCLUDE_SPY) || defined(_DEBUG)
			case SWSPYPACK_GETDOCINFO:
				result = ProcessDocInfo(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETOMNILINKS:
				result = ProcessOmnilinks(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETRELATEDDOCS:
				result = ProcessRelatedDocs(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETRELATEDKEYS:
				result = ProcessRelatedKeys(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETOMNIKEYS:
				result = ProcessOmniKeys(SwConnection, &SwError);
				break;
			case SWSPYPACK_CASESTARTED:
				result = ProcessCaseStarted(SwConnection, &SwError);
				break;
			case SWSPYPACK_CASECLOSED:
				result = ProcessCaseClosed(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETKEYS:
				result = ProcessGetKeys(SwConnection, &SwError);
				break;
			case SWSPYPACK_VALIDATEKEYS:
				result = ProcessValidateKeys(SwConnection, &SwError);
				break;
			case SWSPYPACK_VALIDATEAKEY:
				result = ProcessValidateAKey(SwConnection, &SwError);
				break;
			case SWSPYPACK_UPDATEKEYS:
				result = ProcessUpdateKeys(SwConnection, &SwError);
				break;
			case SWSPYPACK_CHGIMGWPID:
				result = ProcessChangeImageWpid(SwConnection, &SwError);
				break;
			case SWSPYPACK_CHGIMGDOCTYPE:
				result = ProcessChangeImageDocType(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETCASES:
				result = ProcessGetCases(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETPENDCASES:
				result = ProcessGetPendCases(SwConnection, &SwError);
				break;
			case SWSPYPACK_PENDCASECONTROL:
				result = ProcessPendCaseControl(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETIMAGE:
				result = ProcessGetImage(SwConnection, &SwError);
				break;
			case SWSPYPACK_ADDMOREKEYS:
				result = ProcessAddMoreKeys(SwConnection, &SwError);
				break;
#else
			case SWSPYPACK_GETDOCINFO:
			case SWSPYPACK_GETOMNILINKS:
			case SWSPYPACK_GETRELATEDDOCS:
			case SWSPYPACK_GETRELATEDKEYS:
			case SWSPYPACK_GETOMNIKEYS:
			case SWSPYPACK_CASESTARTED:
			case SWSPYPACK_CASECLOSED:
			case SWSPYPACK_GETKEYS:
			case SWSPYPACK_VALIDATEKEYS:
			case SWSPYPACK_VALIDATEAKEY:
			case SWSPYPACK_UPDATEKEYS:
			case SWSPYPACK_CHGIMGWPID:
			case SWSPYPACK_CHGIMGDOCTYPE:
			case SWSPYPACK_GETCASES:
			case SWSPYPACK_PENDCASECONTROL:
			case SWSPYPACK_GETIMAGE:
			case SWSPYPACK_ADDMOREKEYS:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif

#ifdef __ILEC400__
			case SWSPYPACK_RUNAS400PROG:
				result = ProcessRunAS400Prog(SwConnection, &SwError);
				break;
#else
			case SWSPYPACK_RUNAS400PROG:
				result = SwSpySendError(SwConnection, SWSPYERR_NOTSUPPORTED, SwConnection->h
				break;
#endif

			case SWSPYPACK_INITDEBUG:
				result = ProcessInitDebug(SwConnection, &SwError);
				break;
			case SWSPYPACK_GETDEBUGMSGS:
				if (! SwConnection->DebugInitialized) {
					result = SwSpySendError(SwConnection, SWSPYERR_FAILED, SwConnection->header
				} else {
					result = ProcessGetDebugMsgs(SwConnection, &SwError);
				}
				break;

			/* It may be a more current version of the client and we don't know about thi
			   type of packet. Send back an error. Attempt to send proper packet type */
			default:
				TRACEOUT(ERROR, "Unknown packet received: %d\n", SwConnection->header.type);
				result = SwSpySendError(SwConnection, SWSPYERR_UNKNOWNPACKET, SwConnection->
				break;
		}

		if (result < 0) {
			if (result == -1) {
				PrintSwSpyError("Error sending packet", &SwError);
			}
			goto DONE;
		}

#if 0
#ifdef __ILEC400__ /* BIG FAT TEMPORARY KLUGE FOR CITRIX AT KVI */
		if (SwConnection->header.type != SWSPYPACK_GETDEBUGMSGS) {
			if (SwConnection->header.type != SWSPYPACK_INITDEBUG) {
				TRACEOUT(VERBOSE, "Closing client connection (after first packet)\n");
				result = 0;
				goto DONE;
			}
		}
#endif
#endif

	} /* done */

#ifdef HEAP_CHECK
	/* I haven't had any problems, but doesn't hurt to check */
	TRACEOUT(ALWAYS, "Checking heap...\n");
	{ int r;
		if ((r = _heapchk()) != _HEAPOK) {
			TRACEOUT(ERROR, "Heap corrupt: %d\n", r);
		}
	}
#endif

	TRACEOUT(VERBOSE, "Closing client connection\n");

DONE:
	if (SwConnection->DebugInitialized) {
		SwConnection->DebugInitialized = FALSE;
		/* Tell server our user name and new debug level */
#ifdef __ILEC400__
		TRACEOUT(VERBOSE, "Notifying parent I am ready\n");
		if (WriteMainQueue(QUEUECMD_IAMDONE_REMOTEDEBUG, NULL, 0, PARENT_NOTIFICATION_
			TRACEOUT(ERROR, "Error writing NOTREMOTEDEBUG to queue\n");
		}
		TRACEOUT(VERBOSE, "Done notifying parent\n");
#endif
	}
	SwSpyClose(pSwConnection);

#ifdef _DEBUG
	TRACEOUT(ALWAYS, "ProcessConnection() - Heap grew by %d bytes\n", GetUsedHeapBy
#endif
	return result;
}

