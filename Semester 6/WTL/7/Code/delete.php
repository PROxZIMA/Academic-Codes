<?php
require_once "config.php";

// Process delete operation if url contains id parameter
if (isset($_GET["id"]) && !empty(trim($_GET["id"]))) {
  // Get id from url
  $id = trim($_GET["id"]);

  // Prepare a delete statment
  $sql = "DELETE FROM students WHERE id = ?";

  if ($stmt = mysqli_prepare($link, $sql)) {
    // Bind varibale to the statement as parameter
    mysqli_stmt_bind_param($stmt, "i", $id);

    // Execute the statement
    if (mysqli_stmt_execute($stmt)) {
      echo "<script>alert('Record deleted successfully');</script>";
      echo "<script>window.location.href='http://localhost/php_crud/';</script>";
      exit;
    } else {
      echo "Oops something went wrong. Please try again later";
    }
  }
  // Close statement
  mysqli_stmt_close($stmt);

  // close connection
  mysqli_close($link);
} else {
  // Redirect if url doesn't contain id parameter
  echo "<script>window.location.href='http://localhost/php_crud/';</script>";
  exit;
}
