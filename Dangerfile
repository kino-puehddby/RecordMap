if github.pr_title.include? "[WIP]" || github.pr_labels.include?("WIP")
    warn("PR is classed as Work in Progress")
end

warn("a large PR") if git.lines_of_code > 300

github.dismiss_out_of_range_messages
swiftlint.config_file = '.swiftlint.yml'
swiftlint.binary_path = './Pods/SwiftLint/swiftlint'
swiftlint.lint_files inline_mode: true

lgtm.check_lgtm
