//Java program to illustrate Client side
//Implementation using DatagramSocket
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

public class Server
{
 public static void main(String args[]) throws IOException
 {
     //Scanner sc = new Scanner(System.in);
	 int i = 0;
     // Step 1:Create the socket object for
     // carrying the data.
     DatagramSocket ds = new DatagramSocket();

     InetAddress ip = InetAddress.getByName("127.0.0.1");
     byte buf[] = null;

     // loop while user not enters "bye"
     while (i < 100)
     {
         String inp = "/test"; //sc.nextLine();
         
         // convert the String input into the byte array.
         buf = inp.getBytes();

         // Step 2 : Create the datagramPacket for sending
         // the data.
         DatagramPacket DpSend =
               new DatagramPacket(buf, buf.length, ip, 12001);

         // Step 3 : invoke the send call to actually send
         // the data.
         ds.send(DpSend);
         i++;
         System.out.println(i);
         try {
			TimeUnit.SECONDS.sleep(1);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

         // break the loop if user enters "bye"
         if (inp.equals("bye"))
             break;
     }
 }
}