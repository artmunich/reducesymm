SUBROUTINE KSfield(t,y,dydt)

USE nrtype
USE parameters
use nrutil 

IMPLICIT NONE

REAL(DP), INTENT(IN) :: t
REAL(DP), DIMENSION(:), INTENT(IN) :: y
REAL(DP), DIMENSION(:), INTENT(OUT) :: dydt

! Derivs function for KS system.

REAL(DP), DIMENSION(INT(size(y)/2,i4b)) :: Ry, Iy
REAL(DP), DIMENSION(INT(size(y)/2,i4b)) :: Rdydt, Idydt
REAL(DP) :: Rsdum, Isdum
INTEGER :: m,k,d,ndum

d=assert_eq(INT((size(y)-1)/2,i4b),INT((size(dydt)-1)/2,i4b),'KSField')
d=assert_eq(INT((size(y)-1),i4b)-d,d,'KSField-integer')

 
Rsdum=0.0_dp
Isdum=0.0_dp
Ry=y(1:d)
Iy=y(d+1:2*d)
Rdydt=0.0_dp
Idydt=0.0_dp 

DO k=1,d
	Rsdum=0.0_dp
	Isdum=0.0_dp
	DO m=1,k-1 !! a_o,c_o=0
	     	Isdum = Isdum - Iy(m)*Iy(k-m) + Ry(m)*Ry(k-m)
		Rsdum = Rsdum - Iy(m)*Ry(k-m) - Ry(m)*Iy(k-m)
	END DO
	DO m=k+1,d
     		Isdum = Isdum + Iy(m)*Iy(m-k) + Ry(m)*Ry(m-k)  
		Rsdum = Rsdum - Iy(m)*Ry(m-k) + Ry(m)*Iy(m-k)  
	END DO
	DO m=1,d-k !! a_o,c_o=0
		Isdum = Isdum + Iy(m)*Iy(k+m) + Ry(m)*Ry(k+m)
		Rsdum = Rsdum + Iy(m)*Ry(k+m) - Ry(m)*Iy(k+m)
   	END DO
	Idydt(k)= Iy(k)*(1-nu*k**2)*k**2 + k*Isdum
	Rdydt(k)= Ry(k)*(1-nu*k**2)*k**2 + k*Rsdum 
END DO

dydt(1:d)=Rdydt
dydt(d+1:2*d)=Idydt
dydt(2*d+1)=1.0_dp

!print *,dydt
!read (*,*), ndum

END SUBROUTINE KSfield
