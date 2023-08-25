using UniRx;
using UnityEngine;

namespace Chargezuma.Player
{
    /// <summary>
    /// プレイヤーのアニメーション管理
    /// </summary>
    public class PlayerAnimator : PlayerCore
    {
        Animator PAnimator;

        /// <summary>
        /// 初期化
        /// </summary>
        protected override void OnInitialize()
        {
            PAnimator = GetComponent<Animator>();

            PlayerInput.OnMoveDirection
                       .Select(x => x != Vector3.zero)
                       .Subscribe(x => Walk = x)
                       .AddTo(this);

            PlayerInput.OnJump
                       .DistinctUntilChanged()
                       .Subscribe(x => Jump = x)
                       .AddTo(this);

            PlayerInput.OnMoveDirection
                       .Subscribe(x => ChangeRotation(x))
                       .AddTo(this);
        }

        //ジャンプアニメーション
        public bool Jump { set { PAnimator.SetBool("OnJump", value); } }
        //歩くアニメーション
        public bool Walk { set { PAnimator.SetBool("OnWalk", value); } }

        /// <summary>
        /// 回転アニメーション
        /// </summary>
        private void ChangeRotation(Vector3 inputVector)
        {
            var a = new Vector3(inputVector.x, 0, inputVector.z);
            var forward = a;
            if ((Mathf.Abs(forward.magnitude) < 0.1f))
            {
                return;
            }

            var lookRotation = Quaternion.LookRotation(forward);
            transform.rotation = Quaternion.Lerp(
                transform.rotation,
                lookRotation,
                Time.deltaTime * 20.0f
            );
        }
    }
}
