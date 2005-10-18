SUBROUTINE lubksb(a,indx,b)
USE nrtype; USE nrutil, ONLY : assert_eq
IMPLICIT NONE
REAL(DP), DIMENSION(:,:), INTENT(IN) :: a
INTEGER(I4B), DIMENSION(:), INTENT(IN) :: indx
REAL(DP), DIMENSION(:), INTENT(INOUT) :: b

! From NUMERICAL RECIPES IN FORTRAN 90: THE Art of PARALLEL Scientific Computing
!
!Solves the set of N linear equations A  X = B. Here the N �N matrix a is input, not
!as the original matrix A, but rather as its LU decomposition, determined by the routine
!ludcmp. indx is input as the permutation vector of length N returned by ludcmp. b is
!input as the right-hand-side vector B, also of length N, and returns with the solution vector
!X. a and indx are not modified by this routine and can be left in place for successive calls
!with different right-hand sides b. This routine takes into account the possibility that b will
!begin with many zero elements, so it is efficient for use in matrix inversion.
INTEGER(I4B) :: i,n,iii,ll
REAL(DP) :: summ
n=assert_eq(size(a,1),size(a,2),size(indx),'lubksb')
iii=0	!When iii is set to a positive value, it will become the index
		!of the first nonvanishing element of b. We now do
		!the forward substitution, equation (2.3.6). The only new
		!wrinkle is to unscramble the permutation as we go.
do i=1,n
	ll=indx(i)
	summ=b(ll)
	b(ll)=b(i)
	if (iii /= 0) then
		summ=summ-dot_product(a(i,iii:i-1),b(iii:i-1))
	else if (summ /= 0.0) then
			iii=i	!A nonzero element was encountered, so from now on we will
					!have to do the dot product above. 
	end if
	b(i)=summ
end do
do i=n,1,-1 !Now we do the backsubstitution, equation (2.3.7).
	b(i) = (b(i)-dot_product(a(i,i+1:n),b(i+1:n)))/a(i,i)
end do

END SUBROUTINE lubksb
