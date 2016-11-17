<html><div align="center">
<form method="post" onsubmit="return validateForm()" name="brType">
<table class="details">
<tr>
<th colspan="2">Select a branch point type from Project ' . $_POST['project'] . '</th>
</tr>
<tr>
<td><Input type = 'Radio' Name ='brtype' value= 'tag'>Tag</td>
<td><Input type = 'Radio' Name ='brtype' value= 'branch'>Branch</td>
</tr>
</table>
<input type="submit" value="Branch Type"/>
<input type="hidden" name="project" value="' . $_POST['project'] . '"/>
</form>
</div>
