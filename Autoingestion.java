import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintStream;

import java.net.URL;
import java.net.URLEncoder;
import java.net.HttpURLConnection;

import javax.net.ssl.HttpsURLConnection;

import java.text.SimpleDateFormat;
import java.util.Calendar;

/**
 * This is the class provided by Apple for downloading iTunes Connect reports.<br />
 * Decompiled with JD-GUI and cleaned up by William LaFrance.<br />
 * <br />
 * Find more information in section 3.2 of the iTunes Connect Sales and Trends Guide.<br />
 * http://www.apple.com/itunesnews/docs/AppStoreReportingInstructions.pdf
 */
public class Autoingestion
{

    /**
     * Command-line entry point<br />
     * <br />
     * Usage: <i>java Autoingestion john@xyz.com letmein 80012345 Sales Daily Summary 20100204</i>
     * <br /><br />
     * @param arguments	Command line arguments
     */
    public static void main(String[] arguments) throws Throwable
    {
        if ((arguments.length < 6) || (arguments.length > 7)) {
            System.out.println("Please enter all the required parameters. For help, please "
                    + "download the latest User Guide from the Sales and Trends module in iTunes "
                    + "Connect.");
            return;
        }

        String date = null;

        if ((arguments.length == 7) && (arguments[6]) != null) {
            date = arguments[6];
        } else {
            Calendar calendar = Calendar.getInstance();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");
            calendar.add(5, -1);

            date = formatter.format(calendar.getTime()).toString();
        }

        String data = "USERNAME="      + URLEncoder.encode(arguments[0], "UTF-8");
        data = data + "&PASSWORD="     + URLEncoder.encode(arguments[1], "UTF-8");
        data = data + "&VNDNUMBER="    + URLEncoder.encode(arguments[2], "UTF-8");
        data = data + "&TYPEOFREPORT=" + URLEncoder.encode(arguments[3], "UTF-8");
        data = data + "&DATETYPE="     + URLEncoder.encode(arguments[4], "UTF-8");
        data = data + "&REPORTTYPE="   + URLEncoder.encode(arguments[5], "UTF-8");
        data = data + "&REPORTDATE="   + URLEncoder.encode(date, "UTF-8");
    
        HttpURLConnection connection = null;
        try {
            URL url = new URL("https://reportingitc.apple.com/autoingestion.tft?");

            connection = (HttpURLConnection)url.openConnection();
      		connection.setRequestMethod("POST");
      		connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
      		connection.setDoOutput(true);
      		
      		OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
      		out.write(data);
      		out.flush();
      		out.close();

      		if (connection.getHeaderField("ERRORMSG") != null) {
        		System.out.println(connection.getHeaderField("ERRORMSG"));
      		} else if (connection.getHeaderField("filename") != null) {
        		getFile(connection);
        	}
    	} catch (Exception ex) {
      		ex.printStackTrace();
      		System.out.println("The report you requested is not available at this time.  Please try again in a few minutes.");
    	} finally {
      		if (connection != null) {
        		connection.disconnect();
        		connection = null;
      		}
    	}
    }

    /**
     * Download a file from a HTTP connection and write it to file indicated by
     * HTTP header 'filename'
     *
     * @param connection HTTP connection to read downloading file from
     *
     * (Note: The argument was HttpsURLConnection in decompiled code)
     */
	private static void getFile(HttpURLConnection connection) throws IOException {
    	String filename = connection.getHeaderField("filename");
    	System.out.println(filename);

    	BufferedInputStream in = new BufferedInputStream(connection.getInputStream());
    	BufferedOutputStream out = new BufferedOutputStream(new FileOutputStream(filename));

    	int i = 0;
    	byte[] data = new byte[1024];
    	while ((i = in.read(data)) != -1) {
      		out.write(data, 0, i);
    	}

    	in.close();
    	out.close();
    	System.out.println("File Downloaded Successfully ");
  	}
}
