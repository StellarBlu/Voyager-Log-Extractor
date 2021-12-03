# Voyager-Log-Extractor
The Voyager Log Extractor is a Windows 10 batch file to extract human readable logs from StarKeeper.it Voyager logs.

StarKeeper.it Voyager is system integration and astrophotography automation software.  Voyager can be found at https://software.starkeeper.it/.

Voyager generates large log files, often more than 100 MBytes per night.  These logs contain a treasure trove of information, but the details are not paricularly easy to access.  The Voyager Log Extractor filters these logs to produce a more human readable record of the night's astro imaging activities.  The log extract can typically consist of just 0.1% of the number of lines, and 0.05% of the file size of the original Voyager log.

ExtractLog.bat uses GNUWin32 utilities grep.exe and sed.exe to filter and condense records for the Voyager log.  GNUWin32 can be downloaded from http://gnuwin32.sourceforge.net/.  Once downloaded and extracted, ensure the GNUWin32 directory is on your path.  If disk space is limited, the following subset of the GNUWin32 Utilities are sufficient to run ExtractLog.bat:
grep.exe, libiconv2.dll, libintl3.dll, pcre3.dll, regex2.dll and sed.exe.

Place ExtractLog.bat in your Documents\Voyager\ or Documents\Voyager\Log\ directory.

From Windows Explorer, you can
*  Drag a Voyager log file onto ExtractLog.bat to process that log.
*  Drag a directrory onto ExtractLog.bat to process all Voyager logs in that directory.
*  Double click on ExtractLogs.bat to process all logs in the ExtractLogs.bat directory.
  
