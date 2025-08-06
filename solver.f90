module solver
  implicit none
contains

  subroutine solve_system(x, k, T_left, T_right, T, N)
    integer, intent(in) :: N
    real, intent(in) :: x(N), k(N)
    real, intent(in) :: T_left, T_right
    real, intent(out) :: T(N)

    real :: dx(1:N-1)
    real :: A_matrix(N-2, N-2)
    real :: a(2:N-1), b(2:N-1), c(2:N-1), rhs(2:N-1)
    integer :: i

    do i = 1, N-1
      dx(i) = x(i+1) - x(i)
    end do

    ! a(i)T(i-1) + b(i)T(i) + c(i)T(i+1) = rhs(i)
    do i = 2, N-1
      a(i) = (k(i-1) + k(i)) / (2 * dx(i-1))
      c(i) = (k(i) + k(i+1)) / (2 * dx(i))
      b(i) = -(a(i) + c(i))
      rhs(i) = 0.0
    end do

    T(1) = T_left
    T(N) = T_right

    rhs(2) = -a(2) * T(1)
    rhs(N-1) = -c(N-1) * T(N)
 
    A_matrix = 0.0
    do i = 1, N-2
      if (i > 1) A_matrix(i, i-1) = a(i+1)    ! lower
      A_matrix(i, i) = b(i+1)                 ! main
      if (i < N-2) A_matrix(i, i+1) = c(i+1)  ! upper
    end do
  
    call gauss_solver(A_matrix, rhs, T(2:N-1), N-2)
  end subroutine solve_system

  subroutine gauss_solver(A, b, x, N)
    ! Solves the linear system A * x = b using Gaussian elimination.
    ! N: size
    ! A(N,N): coefficient matrix
    ! b(N): rhs vector
    ! x(N): solution vector
    integer, intent(in) :: N
    real, intent(inout) :: A(N, N)
    real, intent(inout) :: b(N)
    real, intent(out) :: x(N)
 
    real :: factor
    integer :: i, j
 
    ! For N = 3
    ! [b(2) c(2)   0 ]   [T(2)]   [rhs(2)]
    ! [a(3) b(3) c(3)] * [T(3)] = [rhs(3)]
    ! [  0  a(4) b(4)]   [T(4)]   [rhs(4)]
 
    ! Forward elimination
    do i = 1, N-1
      factor = A(i+1, i) / A(i, i) ! Hope no divisions by zero happen
      do j = i, N
        A(i+1, j) = A(i+1, j) - factor * A(i, j)
      end do
      b(i+1) = b(i+1) - factor * b(i)
    end do
    ! Now we have an upper triangular system

    ! For N = 3
    ! [A(1,1) A(1,2) A(1,3)]   [x(1)]   [b(1)]
    ! [   0   A(2,2) A(2,3)] * [x(2)] = [b(2)]
    ! [   0      0   A(3,3)]   [x(3)]   [b(3)]

    ! Backward substitution
    do i = N, 1, -1
      x(i) = b(i) ! take the full b generated form the line
      do j = i+1, N
        x(i) = x(i) - A(i, j) * x(j) ! remove every component that formed that ´b´ that wasn't the ´x´ we want
      end do
      x(i) = x(i) / A(i, i) ! since our ´x´ contribution to ´b´ is a multiple of ´A´ we devided it to get ´x´
    end do

  end subroutine gauss_solver

end module solver

