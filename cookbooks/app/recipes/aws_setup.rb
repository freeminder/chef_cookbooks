require 'chef/provisioning/aws_driver'

with_driver 'aws::us-east-1'

# machine_batch do
#   action :destroy
#   machines 'ref-machine1', 'ref-machine2'
# end
# machine 'EFlowerLite' do
#   action :destroy
# end

machine 'EFlowerLite-dev' do
  role 'app'
  machine_options bootstrap_options: {
    image_id: "ami-d05e75b8",
    instance_type: "t2.micro",
    availability_zone: 'us-east-1a',
    key_name: "id_rsa"
  },
  transport_address_location: :public_ip
end
