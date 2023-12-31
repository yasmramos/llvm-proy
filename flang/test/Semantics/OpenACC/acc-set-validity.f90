! RUN: %python %S/../test_errors.py %s %flang -fopenacc

! Check OpenACC clause validity for the following construct and directive:
!   2.14.3 Set

program openacc_clause_validity

  implicit none

  integer :: i, j
  integer, parameter :: N = 256
  real(8), dimension(N) :: a

  !$acc parallel
  !ERROR: Directive SET may not be called within a compute region
  !$acc set default_async(i)
  !$acc end parallel

  !$acc serial
  !ERROR: Directive SET may not be called within a compute region
  !$acc set default_async(i)
  !$acc end serial

  !$acc kernels
  !ERROR: Directive SET may not be called within a compute region
  !$acc set default_async(i)
  !$acc end kernels

  !$acc parallel
  !$acc loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do
  !$acc end parallel

  !$acc serial
  !$acc loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do
  !$acc end serial

  !$acc kernels
  !$acc loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do
  !$acc end kernels

  !$acc parallel loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do

  !$acc serial loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do

  !$acc kernels loop
  do i = 1, N
    !ERROR: Directive SET may not be called within a compute region
    !$acc set default_async(i)
    a(i) = 3.14
  end do

  !ERROR: At least one of DEFAULT_ASYNC, DEVICE_NUM, DEVICE_TYPE clause must appear on the SET directive
  !$acc set

  !ERROR: At least one of DEFAULT_ASYNC, DEVICE_NUM, DEVICE_TYPE clause must appear on the SET directive
  !$acc set if(.TRUE.)

  !ERROR: At most one DEFAULT_ASYNC clause can appear on the SET directive
  !$acc set default_async(2) default_async(1)

  !ERROR: At most one DEFAULT_ASYNC clause can appear on the SET directive
  !$acc set default_async(2) default_async(1)

  !ERROR: At most one DEVICE_NUM clause can appear on the SET directive
  !$acc set device_num(1) device_num(i)

  !ERROR: At most one DEVICE_TYPE clause can appear on the SET directive
  !$acc set device_type(*) device_type(nvidia)

  !$acc set default_async(2)
  !$acc set default_async(i)
  !$acc set device_num(1)
  !$acc set device_num(i)
  !$acc set device_type(default)
  !$acc set device_num(1) default_async(2) device_type(*)

  !ERROR: The DEVICE_TYPE clause on the SET directive accepts only one value
  !$acc set device_type(*, default)

  !ERROR: At least one of DEFAULT_ASYNC, DEVICE_NUM, DEVICE_TYPE clause must appear on the SET directive
  !$acc set

end program openacc_clause_validity
