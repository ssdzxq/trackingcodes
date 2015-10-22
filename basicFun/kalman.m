%% particle filter for 1D signal
clear
N = 500;
iter = 20;
x_s0 = 1;
sigma = 0.5;

X = zeros(1,N);
U = zeros(1,N);
w = zeros(1,N);
X_sample = round(normrnd(x_s0,sigma,1,N)); % ���ӵĳ�ʼ״̬
w0 = 1/N * ones(1,N); % ���ӵĳ�ʼȨ��

sigma_noise = 0.01;
for i = 1:iter
    noise_state = normrnd(0,sigma_noise,1,N); % ģ����������˹����
    X = X_sample + 10 + noise_state; % ״̬ת�Ʒ��� 
    noise_measure = normrnd(0,sigma_noise,1,N); % �۲���������˹����
    U = X + noise_measure; % �۲ⷽ��
    delta = (U - X).^2;
    w = delta/sum(delta);
%     x_new = round(sum(w.*X));
    x_new = sum(w.*X);
    scatter(x_new,i,40,'filled');hold on;axis([0 200 0 25]);
%     X_sample = round(normrnd(x_new,sigma,1,N));
    X_sample = normrnd(x_new,sigma,1,N);
    scatter(X_sample,i*ones(1,N),3,'filled');xlabel('״ֵ̬/�۲�ֵ');ylabel('����');
end

%% particle filter for 2D signal

    
    





















