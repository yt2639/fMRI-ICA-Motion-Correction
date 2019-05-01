function fwd=fd_self_construct(obj)

fprintf('Computing framewise displacement...');

motion=obj;
radius=50;

if(size(motion,2)~=6)
    error(['The motion time series must have 6 motion parameters in 6 columns; the size of the input given is ' num2str(size(motion))])
end

temp=motion(:,4:6);
temp=radius*temp;
motion(:,4:6)=temp;

dts=diff(motion);
dts=[
    zeros(1,size(dts,2));
    dts
    ];  % first element is a zero, as per Power et al 2014
fwd=sum(abs(dts),2);


end