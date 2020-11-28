//
//  TabProtocols.swift
//  EmojibleIOS
//
//  Created by Furkan Yakal on 26.11.2020.
//

import UIKit

//MARK: - Program Tab
protocol ProgramTabButtonAction{
    func newCodeAction()
    func editAction(title: String, code: String)
    func runAction()
    func trashAction()
}

//MARK: - Tutorial Tab
protocol TutorialTabButtonAction{
    func viewAction(title: String, code: String)
    func runAction()
}

//MARK: - Assignment Tab
protocol AssignmentTabAssignmentSectionAction{
    func editAction(assignment: AssignmentModel)
    func trashAction(assignment: AssignmentModel)
}

protocol AssignmentTabVariableSectionAction{
    func variableAction(emoji: String)
}

//MARK: - Assignment Alerts
protocol AssignmentRemovalAlert{
    var assignmentToBeRemoved: AssignmentModel? { get set }
}

protocol AssignmentEditAlert{
    var assignmentToBeEdited: AssignmentModel? { get set }
}

protocol AssignmentNewAssignmentAlert{
    var newAssignmentIdentifier: String? {get set}
}
