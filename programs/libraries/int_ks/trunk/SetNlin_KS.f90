subroutine SetNlin_KS(a,N_a)

use nrtype
use ifc_int_ks
use nrutil, only:assert_eq


implicit none

include "fftw3.f"

complex(dpc), dimension(:), intent(in) :: a
complex(dpc), dimension(:), intent(out) :: N_a
! Returns the nonlinear part N_a in the KSe. Notice it is
! equal to the nonlinear operator acting on a. 
integer(i4b):: d,k 
real(dp), dimension(2*(size(a)-1)) :: v 
complex(dpc), dimension(size(a)) :: adum 
integer(i8b) :: invplan, plan ! needed by fftw3


d=assert_eq(2*(size(a)-1),2*(size(N_a)-1),'SetNlin')

N_a=(0.0_dp,0.0_dp)

adum=a
call dfftw_plan_dft_c2r_1d(invplan,d,adum,v,FFTW_ESTIMATE)
call dfftw_execute(invplan)
call dfftw_destroy_plan(invplan)
v=v**2
call dfftw_plan_dft_r2c_1d(plan,d,v,N_a,FFTW_ESTIMATE)
call dfftw_execute(plan)
call dfftw_destroy_plan(plan)
N_a=N_a/size(v)
do k=1,size(N_a) 
	N_a(k)=ii*Real(k-1,dp)*N_a(k)/L
end do

end subroutine

