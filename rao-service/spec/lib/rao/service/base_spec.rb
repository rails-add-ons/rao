require 'spec_helper'
require 'rao-service'

RSpec.describe Rao::Service::Base do
  it { expect(described_class.ancestors).to include(Rao::Service::Base::AutosaveConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::CallbacksConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ErrorsConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::I18nConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::MessagesConcern) }
  it { expect(described_class.ancestors).to include(Rao::Service::Base::ResultConcern) }
end
