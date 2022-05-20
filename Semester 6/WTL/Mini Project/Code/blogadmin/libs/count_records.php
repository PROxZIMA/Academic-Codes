
<?php
function countrecords($table,$status){
  include("libs/db_connect.php");
  $currentuser=getLoggedMemberID();
  if ($currentuser=="admin") {
    # code...
    if ($status=="all") {
      # code...
       $sql="SELECT * FROM $table ORDER BY id";
    if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      printf("%d",$rowcount);
      // Free result set
      mysqli_free_result($result);
      }
    }
elseif ($status=="publish") {
  # code...
  $sql="SELECT * FROM $table WHERE posted='$status' ORDER BY id";
    if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcounter=mysqli_num_rows($result);
      printf("%d",$rowcounter);
      // Free result set
      mysqli_free_result($result);
      }
}
elseif ($status=="draft") {
  # code...
  $sql="SELECT * FROM $table WHERE posted='$status' ORDER BY id";
    if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcounter=mysqli_num_rows($result);
      printf("%d",$rowcounter);
      // Free result set
     mysqli_free_result($result);
      }
}
    mysqli_close($con);
  }
  else {
    # code...
    if ($status=="all") {
      # code...
      $sql="SELECT * FROM membership_userrecords WHERE tableName='$table' AND memberID='$currentuser' ORDER BY recID";
    if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      printf("%d",$rowcount);
      // Free result set
      mysqli_free_result($result);
      }

    mysqli_close($con);
    }
    elseif ($status=="publish") {
      # code...
      $sql="SELECT * FROM blogs WHERE author='$currentuser' AND posted='$status'";
      if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      printf("%d",$rowcount);
      // Free result set
      mysqli_free_result($result);
      }
    }
    elseif ($status=="draft") {
      # code...
      $sql="SELECT * FROM blogs WHERE author='$currentuser' AND posted='$status'";
      if ($result=mysqli_query($con,$sql))
      {
      // Return the number of rows in result set
      $rowcount=mysqli_num_rows($result);
      printf("%d",$rowcount);
      // Free result set
      mysqli_free_result($result);
      }
    }
    
  }

}
function admincounter($tablename)
{
  include("libs/db_connect.php");
  # code...
  $sql="SELECT * FROM $tablename";
  if ($result=mysqli_query($con,$sql))
    {
    // Return the number of rows in result set
    $rowcount=mysqli_num_rows($result);
    printf("%d",$rowcount);
    // Free result set
    mysqli_free_result($result);
    }

  mysqli_close($con);
}
function adminstats($table1,$table2)
{
  include("libs/db_connect.php");
   $sql="SELECT * FROM $table1";
  if ($result=mysqli_query($con,$sql))
    {
    // Return the number of rows in result set
    $rowcount1=mysqli_num_rows($result);
    $sql="SELECT * FROM $table2";
    if ($result=mysqli_query($con,$sql)) {
      # code...
      $rowcount2=mysqli_num_rows($result);
    }
    $final=$rowcount1+$rowcount2;
    echo $final;
    //skip
    //printf("%d",$rowcount1);
    // Free result set
    //mysqli_free_result($result);
    }

  mysqli_close($con);

}

?>
