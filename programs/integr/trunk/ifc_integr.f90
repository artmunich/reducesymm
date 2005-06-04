MODULE ifc_integr

! Contains all the subroutine declarations.

interface
	subroutine integrP(yi,Delta_x,qfP,yP,nsteps,nstepsP,nInters,sect,derivs)
		USE nrtype 
		IMPLICIT NONE
		integer(i4b), intent(in) :: nsteps, nstepsP, nInters, sect
		real(dp), intent(in) ::  yi(:), Delta_x, qfP
		real(dp), intent(out) :: yP(:,:)
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
				USE nrtype
				IMPLICIT NONE
				REAL(dp), INTENT(IN) :: x
				REAL(dp), DIMENSION(:), INTENT(IN) :: y
				REAL(dp), DIMENSION(:), INTENT(OUT) :: dydx	
			END SUBROUTINE derivs
		END INTERFACE
	end subroutine
end interface


INTERFACE
	SUBROUTINE rk4(x,y,dydx,h,yout,derivs)
		USE nrtype
		IMPLICIT NONE
		REAL(dp), DIMENSION(:), INTENT(IN) :: y,dydx
		REAL(dp), INTENT(IN) :: x,h
		REAL(dp), DIMENSION(:), INTENT(OUT) :: yout
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
				USE nrtype
				IMPLICIT NONE
				REAL(dp), INTENT(IN) :: x
				REAL(dp), DIMENSION(:), INTENT(IN) :: y
				REAL(dp), DIMENSION(:), INTENT(OUT) :: dydx	
			END SUBROUTINE derivs
		END INTERFACE
	END SUBROUTINE
END INTERFACE

INTERFACE
	SUBROUTINE rk4driver(xi,yi,xf,nsteps,y,derivs)
		USE nrtype
		IMPLICIT none
		REAL(dp), INTENT(IN) :: xi,xf
		REAL(dp), DIMENSION(:), INTENT(IN) :: yi
		REAL(dp), DIMENSION(:,:), INTENT(OUT) :: y
		INTEGER(I4B), INTENT(IN) :: nsteps
		INTERFACE
			SUBROUTINE derivs(x,y,dydx)
				USE nrtype
				IMPLICIT NONE
				REAL(dp), INTENT(IN) :: x
				REAL(dp), DIMENSION(:), INTENT(IN) :: y
				REAL(dp), DIMENSION(:), INTENT(OUT) :: dydx	
			END SUBROUTINE derivs
		END INTERFACE
	END SUBROUTINE
END INTERFACE

INTERFACE
	SUBROUTINE rk4P(x,y,dydx,h,yout,derivs,p,sect)
		USE nrtype
		IMPLICIT NONE
		REAL(DP), DIMENSION(:), INTENT(IN) :: y,dydx
		REAL(DP), INTENT(IN) :: x,h
		REAL(DP), DIMENSION(:), INTENT(OUT) :: yout
		INTEGER(I4B), INTENT(IN) :: p,sect
		INTERFACE
			SUBROUTINE derivs(x,y,dydx,kappa)
				USE nrtype
				IMPLICIT NONE
				REAL(DP), INTENT(IN) :: x,kappa
				REAL(DP), DIMENSION(:), INTENT(IN) :: y
				REAL(DP), DIMENSION(:), INTENT(OUT) :: dydx	
			END SUBROUTINE derivs
		END INTERFACE
	END SUBROUTINE rk4P
END INTERFACE

INTERFACE
	SUBROUTINE rk4Pdriver(xi,yi,xf,nsteps,y,derivs,p,sect)
		USE nrtype
		IMPLICIT none
		REAL(DP), INTENT(IN) :: xi,xf
		REAL(DP), DIMENSION(:), INTENT(IN) :: yi
		REAL(DP), DIMENSION(:,:), INTENT(OUT) :: y
		INTEGER(I4B), INTENT(IN) :: nsteps,p,sect
		INTERFACE
			SUBROUTINE derivs(x,y,dydx,kappa)
				USE nrtype
				IMPLICIT NONE
				REAL(DP), INTENT(IN) :: x,kappa
				REAL(DP), DIMENSION(:), INTENT(IN) :: y
				REAL(DP), DIMENSION(:), INTENT(OUT) :: dydx	
			END SUBROUTINE derivs
		END INTERFACE
	END SUBROUTINE rk4Pdriver
END INTERFACE



END MODULE