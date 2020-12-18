program program2
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
end program program2

recursive subroutine compute_string(str, pos, res)
  character(len=200), intent(in) :: str
  integer, intent(out) :: res
  integer, intent(inout) :: pos
  character(len=200) :: s
  character :: op
  character :: ch
  integer :: val
  integer :: stack(200)
  integer :: stackptr

  s = trim(s)
  stackptr = 0

  do while (pos <= len(s))
     ch = str(pos:pos)

     if (ch == ' ') then
        pos = pos + 1
        cycle
     end if

     if (ch == ')') then
        exit
     end if

     val = -1

     if (ch == '(') then
        pos = pos + 1
        call compute_string(str, pos, val)
     end if

     if (ch >= '0' .and. ch <= '9') then
        val = iachar(ch) - iachar('0')
     end if

     if (ch == '+' .or. ch == '*') then
        op = ch
     end if

     if (val >= 0) then
        call shift(stack, stackptr, val)
     else
        if (op == '*') then
           call reduce(stack, stackptr)
           call shift(stack, stackptr, -2)
        else if (op == '+') then
           call shift(stack, stackptr, -1)
        end if
     end if
     pos = pos + 1
  end do
  call reduce(stack, stackptr)
  res = stack(1)
end subroutine compute_string

subroutine shift(stack, stackptr, val)
  integer, intent(inout) :: stack(200)
  integer, intent(inout) :: stackptr
  integer, intent(in) :: val

  stackptr = stackptr + 1
  stack(stackptr) = val
end subroutine shift

subroutine reduce(stack, stackptr)
  integer, intent(inout) :: stack(200)
  integer, intent(inout) :: stackptr
  integer :: res

  do while (stackptr > 1)
     if (stack(stackptr-1) == -1) then
        res = stack(stackptr-2) + stack(stackptr)
     else if (stack(stackptr-1) == -2) then
        res = stack(stackptr-2) * stack(stackptr)
     else
        stop "invalid stack"
     end if

     stackptr = stackptr - 2
     stack(stackptr) = res
  end do
end subroutine reduce
