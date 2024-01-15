require 'spec_helper'
require 'rao-service'

RSpec.describe Rao::Service::Base do
  describe "ActiveJobConcern" do
    before(:each) {allow(Rao::Service).to receive(:active_job_present?).and_return(true) }
    it { expect(described_class.ancestors).to include(Rao::Service::Base::ActiveJobConcern) }
  end
  it { expect(described_class.ancestors).to include(Rao::Service::Base::AutosaveConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::CallbacksConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ErrorsConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::I18nConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::MessagesConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ResultConcern) }
end
