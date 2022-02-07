
function [qp,qe] = BDF2_integration(qe,DFmatrix,Amatrix,Mmatrix,coord,npoin,icase,dt,...
              jac_side,psideh,nside,ngl,imapl,intma,nx,ny,alpha,beta,stages,time,ntime)
          
q0 = qe;


[qp,qe,time] = IRK_integration(qe,DFmatrix,Amatrix,Mmatrix,coord,npoin,icase,dt,...
              jac_side,psideh,nside,ngl,imapl,intma,nx,ny,alpha,beta,stages,time,1);
          

A = 3*Mmatrix - 2*dt*DFmatrix;

Rmatrix = A\Mmatrix;

q = qp;

for itime = 2:ntime
    
    time = time + dt;
    
    qp = Rmatrix*(4*q - q0);
    
    [qe,gradq] = exact_solution(coord,npoin,icase,time);
    
    qp = Neumann_BC_Vector(qp,jac_side,psideh,...
               nside,ngl,imapl,intma,gradq,nx,ny,npoin,2*dt,A);
           
    qp = Dirichlet_BC_vec(qp,psideh,nside,ngl,imapl,intma,qe);
    
    q0 = q;
    
    q = qp;
              
end