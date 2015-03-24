require 'rails_helper'

module RocketJobMissionControl
  RSpec.describe JobsHelper, type: :helper do
    #TODO: Timecop this for stability
    describe "#job_duration" do
      let(:job) { double(:job, status: status, completed?: false, aborted?: false) }

      context "when the job is completed" do
        let(:status) { {started_at: Time.now, completed_at: 1.minute.from_now} }

        before { allow(job).to receive(:completed?).and_return(true) }

        it "returns the time between started at and completed at" do
          expect(helper.job_duration(job)).to eq('1 minute')
        end
      end

      context "when the job is aborted" do
        let(:status) { {started_at: Time.now, aborted_at: 2.minutes.from_now} }

        before { allow(job).to receive(:aborted?).and_return(true) }

        it "returns the time between started at and aborted at" do
          expect(helper.job_duration(job)).to eq('2 minutes')
        end
      end

      context "when the job is not aborted or complated" do
        let(:status) { {started_at: Time.now} }

        it "returns the time between started at and now" do
          expect(helper.job_duration(job)).to eq('5 seconds')
        end
      end
    end

    describe "#job_state_icon" do
      {
        queued:     'fa-bed warning',
        running:    'fa-cog fa-spin primary',
        completed:  'fa-check-circle-o success',
        aborted:    'fa-times-circle-o warning',
        unexpected: 'fa-times-circle-o danger'
      }.each do |state, expected_class|

        context "when the job state is #{state}" do
          it "returns the correct class" do
            expect(helper.job_state_icon(state)).to eq(expected_class)
          end
        end

      end
    end

    describe "#job_class" do
      let(:job) { double(:job, state: job_state) }

      {
        queued:     "warning",
        running:    "primary",
        completed:  "success",
        aborted:    "warning",
        failed:     "danger",
        unexpected: "",
      }.each do |state, expected_class|
        context "when job state is #{state}" do
          let(:job_state) { state }

          it "returns the correct class" do
            expect(helper.job_class(job)).to eq(expected_class)
          end

        end
      end
    end
  end
end
