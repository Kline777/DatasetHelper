# DatasetHelper
Class helper for TDataset
Functions to ease the looping of datasets, getting and setting data.
<h2>Available Functions</h2>
<b>Selector Functions</b>
<ul>
  <li>ALL (All dataset rows)</li>
  <li>CURRENT (Current dataset row)</li>
  <li>SELECT (Rows that match the given expression)</li>
  <li>SELECTNOTEQUAL (Rows that doesnt match the given expression)</li>
  <li>SELECTIN (Rows that match the given expression list) </li>
  <li>SELECTNOTIN (Rows that doesnt match the given expression list) </li>
  <li>FIRST (First row of current selection) </li>
  <li>LAST (Last row of current selection)  </li>
</ul>

<b>Row Group Functions</b>
<ul>
  <li>MIN (Minimum value of a field)</li>
  <li>MAX (Maximum value of a field)</li>
  <li>AVG (Average value of a fieldn)</li>
  <li>SUM (Sum of values of a field)</li>
  <li>COUNT (Row coutn of current selection) </li>
  <li>SETVALUE (Change value of given field to all selected rows ) </li>
  <li>FOREACH (Execute Anonymous procedure in all selected rows) </li>
  <li>DELETE (Deletes all selected rows) </li>
  <li>ASARRAY (Return 2D array with all information of all selected rows) </li>
  <li>ASLIST (Return List of 1D array with all information of all selected rows) </li>
</ul>

<b>Single Row Functions</b>
<ul>
  <li>SETVALUE (Change value of given field in current row) </li>
  <li>GETVALUE (Returns value of given field in current row) </li>
  <li>EXECUTE (Execute Anonymous procedure in current row) </li>
  <li>DELETE (Deletes current row) </li>
  <li>ASARRAY (Return  array with all information of current row) </li>
  <li>RECNO (RecNo of current row in the dataset) </li>
  <li>CREATECOPYROW (Creates new row in dataset with the same values of the current row (Allows Ignore fields) </li>
</ul>

<h2>Usage Examples</h2>
<h4>Get total record count</h4>
<p> totalCount:=myDataset.All.Count;</p> 
<h4>Get record count of rows with category 'Other'</h4>
<p> otherCount:=myDataset.Select('Category','Other').Count;</p> 
<h4>Get record count of rows with category 'Other' and Department = 1</h4>
<p> otherCount:=myDataset.Select('Category','Other').Select('Department',1).Count;</p> 
<h4>Change category for all rows with category 'Other'</h4>
<p> myDataset.Select('Category','Other').SetValue('Category','Misc');</p> 
<h4>Delete all rows with category 'Other'</h4>
<p> myDataset.Select('Category','Other').Delete;</p> 
<h4>Get stock of first row with category 'Other'</h4>
<p> stock:=myDataset.Select('Category','Other').First.GetValue('Stock');</p> 
<h4>Get array with name and stock of first row with category 'Other'</h4>
<p> arr:=myDataset.Select('Category','Other').First.AsArray(['Name','Stock']);</p> 
<h4>Copy first row with category 'Other' overriding ID with value 6</h4>
<p> myDataset.Select('Category','Other').First.CreateCopyRecord(['ID'],[6]);</p> 
