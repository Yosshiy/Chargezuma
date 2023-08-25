using System;
using UnityEngine;

namespace Chargezuma.Enemy
{
    /// <summary>
    /// 触れるとジャンプするエネミー
    /// </summary>
    public class EnemyJump : EnemyCore
    {
        PlayerCollider Collider;

        protected override void OnCollisionEnter(Collision collision)
        {
            try
            {
                if (Collider == null)
                {
                    Collider = collision.gameObject.GetComponent<PlayerCollider>();
                }
            }
            catch (NullReferenceException e)
            {
                Debug.LogError(e);
                Debug.Log("プレイヤーにPlayerColliderがアタッチされていません");
            }
        }

        /// <summary>
        /// ジャンプするメソッド
        /// </summary>
        protected override void PlayAction()
        {
            Collider.OnJump();
        }
    }
}
