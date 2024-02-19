clear all

%m
d_0 = 1;        
a_1 = 0.5;
a_2 = 0.5;
l_1 = 0.25;
l_2 = 0.25;

%rad/m
k_r1 = 1;       
k_r2 = 1;
k_r3 = 50;
k_r4 = 20;

syms theta_1 theta_2 d_3 theta_4 real
syms theta_dot_1 theta_dot_2 d_dot_3 theta_dot_4 real
syms theta_ddot_1 theta_ddot_2 d_ddot_3 theta_ddot_4 real
syms m_l1 m_l2 m_l3 real
syms I_l1 I_l2 I_l4 real
syms I_m1 I_m2 I_m3 I_m4 real
syms F_m1 F_m2 F_m3 F_m4 real

m_l = [m_l1 m_l2 m_l3];
q = [theta_1, theta_2, d_3, theta_4]';
q_dot = [theta_dot_1 theta_dot_2 d_dot_3 theta_dot_4]';
q_ddot = [theta_ddot_1 theta_ddot_2 d_ddot_3 theta_ddot_4]';

dh = [a_1   0	    d_0 	    theta_1
      a_2   pi      0           theta_2
      0     0       d_3	        0
      0   	0       l_1+l_2		theta_4-pi/2];

dh_din =[a_1/2   0	    d_0 	    theta_1
         a_2/2   pi     0           theta_2
         0       0      l_1+d_3	    0
         0   	 0      l_2		    theta_4-pi/2];

A_1 = transf_mat(dh(1,:));
A_2 = transf_mat(dh(2,:));
A_3 = transf_mat(dh(3,:));
A_4 = transf_mat(dh(4,:));
A = [A_1 A_2 A_3 A_4];

T_e = simplify(A_1*A_2*A_3*A_4);

A_1_prime = transf_mat(dh_din(1,:));
A_2_prime = transf_mat(dh_din(2,:));
A_3_prime = transf_mat(dh_din(3,:));

z_0 = [0 0 1]';
z_1 = A_1(1:3,1:3)*z_0;
z_2 = A_1(1:3,1:3)*A_2(1:3,1:3)*z_0;
z_3 = A_1(1:3,1:3)*A_2(1:3,1:3)*A_3(1:3,1:3)*z_0;

p_0_tilde = [0 0 0 1]';

p_0_tilde = [0 0 0 1]';

p_e_tilde =  T_e*p_0_tilde;
p_e = p_e_tilde(1:3,:);

p_0 = p_0_tilde(1:3,:);
p_1_tilde =  A_1*p_0_tilde;
p_1 = p_1_tilde(1:3,:);
p_2_tilde =  A_1*A_2*p_0_tilde;
p_2 = p_2_tilde(1:3,:);
p_3_tilde =  A_1*A_2*A_3*p_0_tilde;
p_3 = p_3_tilde(1:3,:);

p_e_tilde =  T_e*p_0_tilde;
p_e = p_e_tilde(1:3,:);

p_0 = [0 0 1]';
p_l1_tilde =  A_1_prime*p_0_tilde;
p_l1 = p_l1_tilde(1:3,:);
p_l2_tilde =  A_1*A_2_prime*p_0_tilde;
p_l2 = p_l2_tilde(1:3,:);
p_l3_tilde =  A_1*A_2*A_3_prime*p_0_tilde;
p_l3 = p_l3_tilde(1:3,:);

J_l1_P1 = cross(z_0,p_l1-p_0);
J_l2_P1 = cross(z_0,p_l2-p_0);
J_l2_P2 = cross(z_1,p_l2-p_1);
J_l3_P1 = cross(z_0,p_l3-p_0);
J_l3_P2 = cross(z_1,p_l3-p_1);
J_l3_P3 = z_2;

J_l1_P = [J_l1_P1 zeros(3,1) zeros(3,1) zeros(3,1)];
J_l2_P = [J_l2_P1 J_l2_P2    zeros(3,1) zeros(3,1)];
J_l3_P = [J_l3_P1 J_l3_P2    J_l3_P3    zeros(3,1)];

J_l1_O1 = z_0;
J_l2_O1 = z_0;
J_l2_O2 = z_1;
J_l3_O1 = z_0;
J_l3_O2 = z_1;
J_l3_O3 = zeros(3,1);
J_l3_O4 = z_3;

J_l1_O = [J_l1_O1 zeros(3,1) zeros(3,1) zeros(3,1)];
J_l2_O = [J_l2_O1 J_l2_O2    zeros(3,1) zeros(3,1)];
J_l3_O = [J_l3_O1 J_l3_O2    J_l3_O3    J_l3_O4   ];

R_l1 = A_1(1:3,1:3);
R_l2 = A_1(1:3,1:3)*A_2(1:3,1:3);
R_l3 = A_1(1:3,1:3)*A_2(1:3,1:3)*A_4(1:3,1:3);

IL_1 = sym(zeros(3,3));
IL_1(9) = I_l1;
IL_2 = sym(zeros(3,3));
IL_2(9) = I_l2;
IL_3 = sym(zeros(3,3));
IL_3(9) = I_l4;

p_m1 = p_0;
p_m2 = p_1;
p_m3 = p_2;
p_m4 = p_l3;

J_m2_P1 = cross(z_0,p_m2-p_0);
J_m3_P1 = cross(z_0,p_m3-p_0);
J_m3_P2 = cross(z_1,p_m3-p_1);
J_m4_P1 = cross(z_0,p_m4-p_0);
J_m4_P2 = cross(z_1,p_m3-p_1);
J_m4_P3 = z_2;

J_m1_P = [zeros(3,1) zeros(3,1) zeros(3,1) zeros(3,1)];
J_m2_P = [J_m2_P1    zeros(3,1) zeros(3,1) zeros(3,1)];
J_m3_P = [J_m3_P1    J_m3_P2    zeros(3,1) zeros(3,1)];
J_m4_P = [J_m4_P1    J_m4_P2    J_m4_P3    zeros(3,1)];

J_m1_O1 = k_r1*z_0;
J_m2_O1 = J_l2_O1;
J_m2_O2 = k_r2*z_1;
J_m3_O1 = J_l3_O1;
J_m3_O2 = J_l3_O2;
J_m3_O3 = k_r3*z_2;
J_m4_O1 = J_l3_O1;
J_m4_O2 = J_l3_O2;
J_m4_O3 = J_l3_O3;
J_m4_O4 = k_r4*z_2;

J_m1_O = [J_m1_O1 zeros(3,1) zeros(3,1) zeros(3,1)];
J_m2_O = [J_m2_O1 J_m2_O2    zeros(3,1) zeros(3,1)];
J_m3_O = [J_m3_O1 J_m3_O2    J_m3_O3    zeros(3,1)];
J_m4_O = [J_m4_O1 J_m4_O2    J_m4_O3    J_m4_O4   ];

R_m1 = eye(3);
R_m2 = R_l1;
R_m3 = R_l2;
R_m4 = R_l2;

IM_1 = sym(zeros(3,3));
IM_1(9) = I_m1;
IM_2 = sym(zeros(3,3));
IM_2(9) = I_m2;
IM_3 = sym(zeros(3,3));
IM_3(9) = I_m3;
IM_4 = sym(zeros(3,3));
IM_4(9) = I_m4;

B = m_l(1).*J_l1_P'*J_l1_P+m_l(2).*J_l2_P'*J_l2_P +m_l(3).*J_l3_P'*J_l3_P;
B = B + J_l1_O'*R_l1*IL_1*R_l1'*J_l1_O + J_l2_O'*R_l2*IL_2*R_l2'*J_l2_O + J_l3_O'*R_l3*IL_3*R_l3'*J_l3_O;
B = simplify(B + J_m1_O'*R_m1*IM_1*R_m1'*J_m1_O + J_m2_O'*R_m2*IM_2*R_m2'*J_m2_O + J_m3_O'*R_m3*IM_3*R_m3'*J_m3_O + J_m4_O'*R_m4*IM_4*R_m4'*J_m4_O);

for i=1:4
    for j=1:4
        c_ijk = [];
        for k=1:4
           c_ijk = [c_ijk; 1/2*(diff(B(i,j),q(k)) + diff(B(i,k),q(j)) - diff(B(j,k),q(i)))];
        end
        C(i,j) = c_ijk(1)*theta_dot_1 + c_ijk(2)*theta_dot_2 + c_ijk(3)*d_dot_3 + c_ijk(4)*theta_dot_4;
    end
end


g0 = [0 0 -9.81]';
g1 = -(m_l1*g0'*J_l1_P(:,1) + m_l2*g0'*J_l2_P(:,1) + m_l3*g0'*J_l3_P(:,1));
g2 = -(m_l1*g0'*J_l1_P(:,2) + m_l2*g0'*J_l2_P(:,2) + m_l3*g0'*J_l3_P(:,2));
g3 = -(m_l1*g0'*J_l1_P(:,3) + m_l2*g0'*J_l2_P(:,3) + m_l3*g0'*J_l3_P(:,3));
g4 = -(m_l1*g0'*J_l1_P(:,4) + m_l2*g0'*J_l2_P(:,4) + m_l3*g0'*J_l3_P(:,4));
g =[g1 g2 g3 g4]';

F_v = diag([F_m1 F_m2 F_m3 F_m4]);

syms q_ddot_1_r q_ddot_2_r q_ddot_3_r q_ddot_4_r real
syms q_dot_1_r q_dot_2_r q_dot_3_r q_dot_4_r real
q_ddot_r = [q_ddot_1_r q_ddot_2_r q_ddot_3_r q_ddot_4_r]';
q_dot_r = [q_dot_1_r q_dot_2_r q_dot_3_r q_dot_4_r]';

tau_sigma=B*q_ddot_r+C*q_dot_r+F_v*q_dot_r+g;

param = [m_l1 m_l2 m_l3 I_l1 I_l2 I_l4 I_m1 I_m2 I_m3 I_m4 F_m1 F_m2 F_m3 F_m4];

for i=1:4
    for j=1:14
        Y(i,j) = diff(tau_sigma(i),param(j));
    end
end
Y