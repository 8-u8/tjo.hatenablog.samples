function yvec=tjo_LR_main(xvec)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���W�X�e�B�b�N��A���ފ� by Takashi J. OZAKI %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���ɒP����2�����̃��W�X�e�B�b�N��A�̎����R�[�h�ł��B
% ������ yvec=tjo_LR_main([2;2]) �ƃR�}���h���C���œ��͂��Ă݂ĉ������B
% �Y��Ȑ��`�����֐��p�^�[�����v���b�g�����͂��ł��B

% ���W�X�e�B�b�N��A�́u��A�v�Ɩ��t�����Ă��܂����A����Ă��邱�Ƃ�
% 2�l�N���X�i�������͕����N���X�j���ނ��s�����R���镪�ފ�ł��B
% ���W�X�e�B�b�N���z�֐����V�O���C�h�֐���p����2�l�N���X�����`�Ɋw�K���A
% �A�����z���镪�������ʌQ���Z�o���邱�ƂŁA�P�Ȃ�2�l�N���X���ނ��s�������łȂ�
% �u�A���ʁi�m���j�v�Ƃ���2�l�N���X���ނ�\�����邱�Ƃ��\�ɂ��Ă܂��B
% �����A0 or 1�ł͂Ȃ��Ⴆ��0.25, 0.80�Ƃ������u�ǂꂭ�炢�̊m���ł��ꂼ���
% �N���X�ɕ��ނ���邩�v��\�����Ƃ��ł��܂��B
% ���������̕��@�_��SVM�̃}�[�W���ɑ΂��ēK�p���邱�Ƃ��ł��邽�߁A
% �K���������W�X�e�B�b�N��A�Ǝ��̂��̂ł͂Ȃ��_�ɒ��ӂ��K�v�ł��B

% ���W�X�e�B�b�N��A�̊�{�I�Ȕ��z�́A���W�b�g�E���f���ɂ����[0,1]��
% ��ʉ����`���f����A�ł��B�����A
% 
% log(p/1-p) = b0 + b1*x
% 
% �Ȃ郍�W�b�g�ϊ����`���f�������肷��ƁAp�̊m�����z�͏�̎���ό`����
% 
% P(X <= x) = 1 / (1 + exp(b0 + b1*x))
% 
% �Ȃ郍�W�X�e�B�b�N���z�ɏ]���܂��B������1�Ԗڂ̎��𕁒ʂɍŏ����@��
% �����Βʏ�̈�ʉ����`���f����A�ɂȂ�̂ł����A������K�`�K�`�ɋ@�B�w�K
% ���ފ�Ƃ��Ďg���Ă��܂����Ƃ����̂����W�X�e�B�b�N��A�ł��B
% 
% ���z�Ƃ��Ă͂悭����x�C�Y����̉��p�ł��B�܂��A��������x�N�g��x��
% �N���XC1��������C2�̂ǂ��炩�ɓ��鎖��m�����l���܂��B���̏ꍇ�A
% 
% p(C1|x) = y(x) = ��(w'*x)
% �i��������(a) = 1 / (1 + exp(-a))�Ȃ�V�O���C�h�֐��j
% 
% �ƕ\���܂��B
% �����ŋ��t�M��x_n�A�������x���M��t_n�i0 or 1�Œ�`�j�ɂ���āA
% �d�݃x�N�g��w���w�K�����邱�Ƃ��l���Ă݂܂��B�Ŗސ���̂������l�ɁA
% w�Ɋւ���ޓx�֐���
% 
% p(t|w) = ��y_n^(t_n){1-y_n}^(1-t_n)
% 
% �Ə����\���܂��B�����Ō덷�֐��i�ޓx�֐��̕��̑ΐ��j���l����ƁA
% 
% E(w) = -ln{p(t|w)} = -��{t_n*ln(y_n) + (1-t_n)*ln(1-y_n)}
% 
% �ƕ\���܂��B���̌덷�֐����ŏ�������w����͓I�ɋ��߂邱�Ƃ͂ł��Ȃ��̂ŁA
% �����d�ݕt���ŏ����@(IRLS)�ƌĂ΂��q���[���X�e�B�b�N��@��p���܂��B
% 
% ���̂��߂ɂ́�E(w)��H = �ށ�E(w)��2�����߂܂��B���ꂼ��
% 
% ��E(w) = ��(y_n-t_n)*x_n
% H = ��y_n*(1-y_n)*x_n*x_n'
% 
% �Ƌ��܂�܂��B����d�݃x�N�g��w�̍X�V����
% 
% w_new = w_old - inverse(H)*��E(w)
% �iinverse()�͋t�s�񉉎Z�j
% 
% �Ȃ�IRLS�@�ɏ]���ŋ}�~���@�`�b�N�Ȍ`�ŕ\����܂��B
% �Ȃ��A�㎮�̒ʂ�t�s��̉��Z���K�v�ƂȂ邽�߁A
% Java�Ȃǂł͐��`�㐔���Z�̃��C�u������p�ӂ���K�v������܂��B
% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
% ����K���͍ŏ��Ɍ��ꂽ���̒ʂ�A
%  
% p(C_n|x) = ��(w'*x)
% 
% �ŕ\����܂��B���苫�E��0.5�ł��i�V�O���C�h�֐��̒��_�j�B
% ���̒l���R���g���[�����āA���������w�K�������ς��Ă�邱�ƂŁA
% ���N���X���ނ��\�ɂȂ�܂��B

%%
%%%%%%%%%%%%%%%%%
% ���t�M���̐ݒ� %
%%%%%%%%%%%%%%%%%
% ���̋@�B�w�K���ފ�̃R�[�h�T���v���ƑS�������ł��B
% ones�֐���xy���W���4�̏ی��Ɋ�_���΂�T���A
% rand�֐��ł΂����^���Ă���܂��B

c=8; % rand�֐��̂΂���̑傫�������߂܂��B

q1=[(1*ones(1,10)+c*rand(1,10));(1*ones(1,10)+c*rand(1,10));ones(1,10)];    % ��1�ی�
q2=[(-1*ones(1,10)-c*rand(1,10));(1*ones(1,10)+c*rand(1,10));ones(1,10)];   % ��2�ی�
q3=[(-1*ones(1,10)-c*rand(1,10));(-1*ones(1,10)-c*rand(1,10));ones(1,10)];  % ��3�ی�
q4=[(1*ones(1,10)+c*rand(1,10));(-1*ones(1,10)-c*rand(1,10));ones(1,10)];   % ��4�ی�

x1_list=[q1 q2 q4]; % �����ɂ͔���`�ł͂Ȃ����ǁA�΂�̂���p�^�[����Group 1
x2_list=[q3];       % �c��̑�3�ی���Group 2

c1=size(x1_list,2); % x1_list�̗v�f��
c2=size(x2_list,2); % x2_list�̗v�f��
clength=c1+c2; % �S�v�f���F���̌㖈��Q�Ƃ��邱�ƂɂȂ�܂��B

% ����M���Fx1��x2�Ƃŕ����������̂ŁA�Ή�����C���f�b�N�X��1��-1������U��܂��B
x_list=[x1_list x2_list]; % x1_list��x2_list���s�����ɕ��ׂĂ܂Ƃ߂܂��B
y_list=[ones(c1,1);zeros(c2,1)]; % ����M����x1:1, x2:0�Ƃ��ė�x�N�g���ɂ܂Ƃ߂܂��B

%%%%%%%%%%%%%%%
% �����p�[�g %
%%%%%%%%%%%%%%%
pause on;

figure(1); % �v���b�g�E�B���h�E��1���
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');
xlim([-10 10]);
ylim([-10 10]);

pause(3);
%%%%%%%%%%%%%%%%%%%%%
% �����p�[�g�I��� %
%%%%%%%%%%%%%%%%%%%%%
%%

wvec=[0;0;1];

%%
[wvec,nE,H]=tjo_LR_train(wvec,x_list,y_list,clength);

yvec=tjo_LR_predict(wvec,[xvec;1]);

%%
%%%%%%%%%%%%%%%
% �����p�[�g %
%%%%%%%%%%%%%%%
figure(2); % �v���b�g�E�B���h�E��1���
scatter(x1_list(1,:),x1_list(2,:),100,'ko');hold on;
scatter(x2_list(1,:),x2_list(2,:),100,'k+');hold on;
xlim([-10 10]);
ylim([-10 10]);

if(yvec > 0.5) % �e�X�g�M��xvec��Group 1�Ȃ�Ԃ����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red');hold on;
    fprintf(1,'\n\nGroup 1\n\n');
elseif(yvec < 0.5) % �e�X�g�M��xvec��Group 2�Ȃ�Ԃ��{�Ńv���b�g
    scatter(xvec(1),xvec(2),200,'red','+');hold on;
    fprintf(1,'\n\nGroup 2\n\n');
else % �e�X�g�M��xvec�����ꕪ�������ʏ�Ȃ�����Ńv���b�g
    scatter(xvec(1),xvec(2),200,'blue');hold on;
    fprintf(1,'\n\nOn the border\n\n');
end;

% �R���^�[�i�������j�v���b�g�B����̂ŏڍׂ�Matlab�w���v�����Q�Ɖ������B
[xx,yy]=meshgrid(-10:0.1:10,-10:0.1:10);
cxx=size(xx,2);
zz=zeros(cxx,cxx);
for p=1:cxx
    for q=1:cxx
        zz(p,q)=tjo_LR_predict(wvec,[xx(p,q);yy(p,q);1]);
    end;
end;
contour(xx,yy,zz,50);hold on;

pause off;
%%%%%%%%%%%%%%%%%%%%%
% �����p�[�g�I��� %
%%%%%%%%%%%%%%%%%%%%%
end