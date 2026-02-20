/**
 * supply-workflows
 * workflows for Supply Chain
 */

export class Agent {
  constructor(options = {}) {
    this.name = 'supply-workflows';
    this.options = options;
  }

  async execute(task) {
    return {
      success: true,
      vertical: 'supply',
      package: 'workflows',
      task,
    };
  }
}

export default Agent;
