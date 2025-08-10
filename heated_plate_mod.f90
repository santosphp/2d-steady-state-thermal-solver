module heated_plate_mod

!*****************************************************************************80
!
!  Purpose:
!
!    Provide a 2d stead-state thermal solver.
!
!  Discussion:
!
!    This code solves the steady state heat equation on a rectangular region.
!
!    The sequential version of this program needs approximately
!    18/eps iterations to complete. 
!
!
!    The physical region, and the boundary conditions, are suggested
!    by this diagram;
!
!                   T = 0
!             +------------------+
!             |                  |
!    T = 100  |                  | T = 100
!             |                  |
!             +------------------+
!                   T = 100
!
!    The region is covered with a grid of M by N nodes, and an N by N
!    array T is used to record the temperature.  The correspondence between
!    array indices and locations in the region is suggested by giving the
!    indices of the four corners:
!
!                  I = 0
!          [0][0]-------------[0][N-1]
!             |                  |
!      J = 0  |                  |  J = N-1
!             |                  |
!        [M-1][0]-----------[M-1][N-1]
!                  I = M-1
!
!    The steady state solution to the discrete heat equation satisfies the
!    following condition at an interior grid point:
!
!      T[Central] = (1/4) * ( T[North] + T[South] + T[East] + T[West] )
!
!    where "Central" is the index of the grid point, "North" is the index
!    of its immediate neighbor to the "north", and so on.
!   
!    Given an approximate solution of the steady state heat equation, a
!    "better" solution is given by replacing each interior point by the
!    average of its 4 neighbors - in other words, by using the condition
!    as an ASSIGNMENT statement:
!
!      T[Central]  <=  (1/4) * ( T[North] + T[South] + T[East] + T[West] )
!
!    If this process is repeated often enough, the difference between 
!    successive estimates of the solution will go to zero.
!
!    This program carries out such an iteration, using a tolerance specified by
!    the user, and writes the final estimate of the solution to a file that can
!    be used for graphic processing.
!
!  Licensing:
!
!    This code is distributed under the GNU LGPL license. 
!
!  First modified:
!
!    15 July 2010
!
!  Author:
!
!    Original FORTRAN90 version by Michael Quinn.
!    First modified by John Burkardt.
!    Lastly modified by Pedro H. Santos P.
!
!  Reference:
!
!    Michael Quinn,
!    Parallel Programming in C with MPI and OpenMP,
!    McGraw-Hill, 2004,
!    ISBN13: 978-0071232654,
!    LC: QA76.73.C15.Q55.
!
!  Local variables:
!
!    Local, real ( kind = 8 ) DIFF, the norm of the change in the solution from 
!    one iteration to the next.
!
!    Local, real ( kind = 8 ) MEAN, the average of the boundary values, used 
!    to initialize the values of the solution in the interior.
!
!    Local, real ( kind = 8 ), allocatable :: U(:,:), the solution at the previous iteration.
!
!    Local, real ( kind = 8 ) T(M,N), the solution computed at the latest 
!    iteration.
!
!    Local, integer ( kind = 4 ) I, J,  the loop indices.
!

  implicit none

contains
  subroutine heated_plate_solver(m, n, top, bottom, left, right, tol, T)

    integer ( kind = 4 ), intent(in) :: m, n
    real( kind = 8 ), intent(in) :: top, bottom, left, right
    real( kind = 8 ), intent(in) :: tol
    real( kind = 8 ), intent(out) :: T(m, n)
 
    real( kind = 8 ) :: diff
    real( kind = 8 ) :: mean
    real( kind = 8 ), allocatable :: u(:,:)
    integer ( kind = 4 ) :: i, j
 
    allocate(u(m, n))

    !  Set the boundary values, which don't change. 
    T(2:m-1,1) = left
    T(2:m-1,n) = right
    T(1,1:n) = top
    T(m,1:n) = bottom

    !  Average the boundary values, to come up with a reasonable
    !  initial value for the interior.
    mean = ( &
        sum ( T(2:m-1,1) ) &
      + sum ( T(2:m-1,n) ) &
      + sum ( T(1,1:n)   ) &
      + sum ( T(m,1:n)   ) ) &
      / real ( 2 * m + 2 * n - 4, kind = 8 )
   
    !  Initialize the interior solution to the mean value.
    T(2:m-1,2:n-1) = mean
   
    !  Iterate until the new solution T differs from the old solution U
    !  by no more than TOL.
    diff = tol + 1.0
    do while (diff > tol)
      u = T  ! Save previous solution

      ! Update solution (serial)
      do j = 2, n-1
        do i = 2, m-1
          T(i,j) = 0.25 * (u(i-1,j) + u(i+1,j) + u(i,j-1) + u(i,j+1))
        end do
      end do

      ! Check convergence
      diff = maxval(abs(T - u))
    end do

    deallocate(u)
  end subroutine heated_plate_solver
end module heated_plate_mod

