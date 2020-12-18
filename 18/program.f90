program program
  integer :: ios
  character(len=200) :: line
  integer :: val
  integer :: pos
  integer :: total

  total = 0
  open(18, file="input.txt", iostat=ios)
  do
     read(18, "(A)", iostat=ios) line
     if (ios /= 0) exit
     pos = 1
     call compute_string(line, pos, val)
     total = total + val
  end do
  print *, total
end program program

recursive subroutine compute_string(str, pos, res)
  character(len=200), intent(in) :: str
  integer, intent(out) :: res
  integer, intent(inout) :: pos
  character :: op
  character :: ch
  integer :: val

  op = ' '

  do while (pos <= len(trim(str)))
     ch = str(pos:pos)
     select case (ch)
     case ('0':'9')
        val = iachar(ch) - iachar('0')
        if (op == '+') then
           res = res + val
        else if (op == '*') then
           res = res * val
        else
           res = val
        end if
     case ('+', '*')
        op = ch
     case (' ')
     case ('(')
        pos = pos + 1
        call compute_string(str, pos, val)
        if (op == '+') then
           res = res + val
        else if (op == '*') then
           res = res * val
        else
           res = val
        end if
     case (')')
        exit
     case default
        stop "invalid character"
     end select
     pos = pos + 1
  end do
end subroutine compute_string
