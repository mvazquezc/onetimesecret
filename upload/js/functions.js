function dropConfirmation() 
{
  if (confirm('This action will destroy the secret\n\nAre you sure?'))
  {
    mainForm.submit();
  } 
  else 
  {
    return false;
  }
}
