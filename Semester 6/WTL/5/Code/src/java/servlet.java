import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.*;

public class servlet extends HttpServlet {

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            
            Class.forName("com.mysql.jdbc.Driver");
            con = (Connection)DriverManager.getConnection("jdbc:mysql://localhost/wt","root","tiger");
            stmt = con.createStatement();
            rs = stmt.executeQuery("select * from ebookshop;");
            
            out.println("<html>");
            out.println("<head><title>Books</title></head>");
            out.println("<body>");
            out.println("<h1>Books</h1>");
            out.println("<table border='1'>");
            out.println("<tr><th>Id</th><th>Title</th><th>Author</th><th>Price</th><th>Quantity</th></tr>");
            
            while (rs.next()) 
             {  
                 String id = rs.getString("book_id");  
                 String title = rs.getString("book_title");
                 String author = rs.getString("book_author");  
                 String price = String.valueOf(rs.getInt("book_price"));  
                 String quantity = String.valueOf(rs.getInt("quantity"));   
                 
                 out.println("<tr><td>" + id + "</td><td>" + title + "</td><td>" + author + "</td><td>" + price + "</td><td>" + quantity + "</td></tr>");   
             }  
             out.println("</table>");  
             out.println("</html></body>");  
             con.close();  
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}