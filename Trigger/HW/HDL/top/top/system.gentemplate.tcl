proc pngeninsttemplate {} {
  cd C:/emb_linux/fxt_evaluation_git_linux_edk10_1_2/v5fx30t_Linux
  if { [xload xmp system.xmp] != 0 } {
    return -1
  }
  if { [catch {run mhs2hdl} result] } {
    return -1
  }
  return 0
}
if { [catch {pngeninsttemplate} result] } {
  exit -1
}
exit $result
