/** 
 * SOAPClient4XG. Read the SOAP envelope file passed as the second
 * parameter, pass it to the SOAP endpoint passed as the first parameter, and
 * print out the SOAP envelope passed as a response.  with help from Michael
 * Brennan 03/09/01
 * 
 *
 * @author  Bob DuCharme
 * @version 1.1
 * @param   SOAPUrl      URL of SOAP Endpoint to send request.
 * @param   xmlFile2Send A file with an XML document of the request.  
 *
 * 5/23/01 revision: SOAPAction added
*/

import java.io.*;
import java.net.*;

public class SOAPClient4XG {
    public static void main(String[] args) throws Exception {

        if (args.length  < 1) {
            System.err.println("Usage:  java SOAPClient4XG " +
                               "environment");
            System.exit(1);
        }

        String env = args[0];
        String xmlFile2Send = "messages/" + env + ".xml";

	String SOAPAction = "";
        java.util.Properties props = new java.util.Properties();
        java.io.File f = new java.io.File("tester.properties");
        java.io.FileInputStream fis = new java.io.FileInputStream(f);
        props.load(fis);
        fis.close();
				
        try{
            // Create the connection where we're going to send the file.
            URL url = new URL(props.getProperty(env + ".endpoint"));
            URLConnection connection = url.openConnection();
            HttpURLConnection httpConn = (HttpURLConnection) connection;

            FileInputStream fin = new FileInputStream(xmlFile2Send);

            ByteArrayOutputStream bout = new ByteArrayOutputStream();
    
            // Copy the SOAP file to the open connection.
            copy(fin,bout);
            fin.close();

            byte[] b = bout.toByteArray();

            // Set the appropriate HTTP parameters.
            httpConn.setRequestProperty( "Content-Length",
                                     String.valueOf( b.length ) );
            httpConn.setRequestProperty("Content-Type","application/soap+xml; charset=utf-8");
	    httpConn.setRequestProperty("SOAPAction",SOAPAction);
            httpConn.setRequestProperty("Authorization", "Basic "+ props.getProperty(env + ".auth"));
            httpConn.setRequestMethod( "POST" );
            httpConn.setDoOutput(true);
            httpConn.setDoInput(true);

            // Everything's set up; send the XML that was read in to b.
            OutputStream out = httpConn.getOutputStream();
            out.write( b );    
            out.close();

            // Read the response and write it to standard out.
            InputStreamReader isr =
                new InputStreamReader(httpConn.getInputStream());
            BufferedReader in = new BufferedReader(isr);

            String inputLine;
            java.lang.StringBuffer sb = new java.lang.StringBuffer();
            boolean result = true;
            while ((inputLine = in.readLine()) != null){
                sb.append(inputLine);
                if(inputLine.contains("FAIL")){
                    result = false;
                }
            }
            in.close();
            if(!result){
                System.err.println(sb.toString());
                System.exit(-1);
            }
            System.out.println("CAAS Springws plugin verification passed.");
            System.out.println(sb.toString());
       }catch(Exception e){
            System.err.println(e.getMessage());
            System.err.println("CAAS Springws plugin verification failed.");
            System.exit(-1);
       }
    }

  // copy method from From E.R. Harold's book "Java I/O"
  public static void copy(InputStream in, OutputStream out) 
   throws IOException {

    // do not allow other threads to read from the
    // input or write to the output while copying is
    // taking place

    synchronized (in) {
      synchronized (out) {

        byte[] buffer = new byte[256];
        while (true) {
          int bytesRead = in.read(buffer);
          if (bytesRead == -1) break;
          out.write(buffer, 0, bytesRead);
        }
      }
    }
  } 
}

